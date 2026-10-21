class CaCertificates < Formula
  desc "Mozilla CA certificate store"
  homepage "https://curl.se/docs/caextract.html"
  url "https://curl.se/ca/cacert-2026-10-20.pem"
  sha256 "796f1389bfea13c0ed78f663b765baaff54a508e5483786bd6ece73c5e3e3cbe"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?cacert[._-](\d{4}-\d{2}-\d{2})\.pem/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8589f4e61b3afcc5ea375aab11af1c891ec4c94421c699c2a5a4765078de4443"
  end

  deny_network_access!

  EXCLUDED_SPKI_HASHES = %w[
    bd153ed7b0434f6886b17bce8bbe84ed340c7132d702a8f4fa318f756ecbd6f3
    c619e4780ed8e0abeda24ad732567de4383a7ea941338f6d1a7d1b49ac792fe9
    8d417db2dd8bf5e3084d1e3f196d583849d81bdd4c00c70b9d39369e96b8c782
  ].freeze

  def install
    require "openssl"

    certificates = OpenSSL::X509::Certificate.load_file("cacert-#{version}.pem").reject do |certificate|
      EXCLUDED_SPKI_HASHES.include?(Digest::SHA256.hexdigest(certificate.public_key.public_to_der))
    end
    (pkgshare/"cacert.pem").write certificates.map(&:to_pem).join

    post_install = libexec/"post-install"
    post_install.write <<~'BASH'.sub("@EXCLUDED_SPKI_HASHES@", EXCLUDED_SPKI_HASHES.join("|"))
      #!/bin/bash
      # Build a CA bundle from trusted system and Mozilla certificates.
      set -euo pipefail
      shopt -s nullglob

      if [[ "$#" -ne 2 ]]; then
        echo "usage: post-install SOURCE DESTINATION" >&2
        exit 1
      fi

      source_file="$1"
      destination="$2"
      destination_dir="${destination%/*}"
      mkdir -p "$destination_dir"

      # Build beside the destination so the final rename cannot expose a partial bundle.
      work_dir="$(mktemp -d "${destination_dir}/.ca-certificates.XXXXXX")"
      trap 'rm -rf "$work_dir"' EXIT
      fingerprints_file="$work_dir/fingerprints"
      bundle_file="$work_dir/cert.pem"
      : >"$fingerprints_file"
      : >"$bundle_file"

      # Split concatenated PEM bundles so each certificate can be validated independently.
      split_certificates() {
        local input_file="$1"
        local output_dir="$2"
        mkdir -p "$output_dir"
        awk -v output_dir="$output_dir" '
          /-----BEGIN CERTIFICATE-----/ {
            certificate = ""
            writing_certificate = 1
          }
          writing_certificate {
            certificate = certificate $0 ORS
          }
          /-----END CERTIFICATE-----/ && writing_certificate {
            output_file = output_dir "/" ++certificate_count ".pem"
            printf "%s", certificate > output_file
            close(output_file)
            writing_certificate = 0
          }
        ' "$input_file"
      }

      # Track fingerprints while appending to discard malformed and duplicate certificates.
      append_unique_certificate() {
        local certificate_file="$1"
        local openssl_command="$2"
        local fingerprint spki_hash
        fingerprint="$("$openssl_command" x509 -inform pem -fingerprint -sha256 -noout \
          <"$certificate_file" 2>/dev/null)" || return 0
        grep -Fqx "$fingerprint" "$fingerprints_file" && return

        # Exclude AAA Certificate Services and the emSign G3 roots by their public keys.
        spki_hash="$("$openssl_command" x509 -inform pem -pubkey -noout <"$certificate_file" 2>/dev/null |
          "$openssl_command" pkey -pubin -outform der 2>/dev/null |
          "$openssl_command" dgst -sha256 -r)" || return 0
        case "${spki_hash%% *}" in
          @EXCLUDED_SPKI_HASHES@) return 0 ;;
        esac

        printf '%s\n' "$fingerprint" >>"$fingerprints_file"
        cat "$certificate_file" >>"$bundle_file"
        printf '\n' >>"$bundle_file"
      }

      # Append every valid, unique certificate from a PEM bundle.
      append_bundle() {
        local input_file="$1"
        local output_dir="$2"
        local openssl_command="$3"
        local certificate_file
        split_certificates "$input_file" "$output_dir"
        for certificate_file in "$output_dir"/*.pem; do
          append_unique_certificate "$certificate_file" "$openssl_command"
        done
      }

      # Include only unexpired keychain certificates trusted for server TLS.
      append_keychain() {
        local keychain="$1"
        local purpose="$2"
        local output_dir="$work_dir/keychain-$purpose"
        local certificate_file
        /usr/bin/security find-certificate -a -p "$keychain" >"$work_dir/keychain.pem"
        split_certificates "$work_dir/keychain.pem" "$output_dir"
        for certificate_file in "$output_dir"/*.pem; do
          /usr/bin/openssl x509 -inform pem -checkend 0 -noout <"$certificate_file" &>/dev/null || continue
          /usr/bin/openssl x509 -inform pem -purpose -noout <"$certificate_file" 2>/dev/null |
            grep -Fq "SSL server CA : Yes" || continue
          /usr/bin/security verify-cert -l -L -c "$certificate_file" -p "$purpose" -R offline &>/dev/null ||
            continue
          append_unique_certificate "$certificate_file" /usr/bin/openssl
        done
      }

      if [[ "$(uname -s)" == "Darwin" ]]; then
        # Begin with system trust, then append Mozilla certificates not already present.
        append_keychain "/Library/Keychains/System.keychain" ssl
        append_keychain "/System/Library/Keychains/SystemRootCertificates.keychain" basic
        append_bundle "$source_file" "$work_dir/mozilla" /usr/bin/openssl
      else
        # Merge the first standard system CA bundle found with the Mozilla bundle.
        system_bundle=""
        for candidate in \
          /etc/ssl/certs/ca-certificates.crt \
          /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
          /etc/ssl/ca-bundle.pem; do
          if [[ -f "$candidate" && -r "$candidate" ]]; then
            system_bundle="$candidate"
            break
          fi
        done
        openssl_command="$(command -v openssl || true)"
        if [[ -n "$system_bundle" && -n "$openssl_command" ]]; then
          append_bundle "$system_bundle" "$work_dir/system" "$openssl_command"
          append_bundle "$source_file" "$work_dir/mozilla" "$openssl_command"
        else
          echo "Cannot find a readable system CA bundle or OpenSSL; using Mozilla certificates only." >&2
          output_dir="$work_dir/mozilla"
          split_certificates "$source_file" "$output_dir"
          for certificate_file in "$output_dir"/*.pem; do
            cat "$certificate_file" >>"$bundle_file"
            printf '\n' >>"$bundle_file"
          done
        fi
      fi

      chmod 0644 "$bundle_file"
      mv -f "$bundle_file" "$destination"
    BASH
    chmod 0755, post_install
  end

  post_install_steps do
    run "post-install", args: ["{{pkgshare}}/cacert.pem", "{{pkgetc}}/cert.pem"], base: :libexec
  end

  def caveats
    on_macos do
      <<~EOS
        CA certificates have been bootstrapped using certificates from the system keychain.
      EOS
    end

    on_linux do
      <<~EOS
        CA certificates have been bootstrapped from both the Mozilla CA store and the system CA store at
        one of the following locations, depending on your distro:

          /etc/ssl/certs/ca-certificates.crt                 # Debian/Ubuntu, Alpine Linux, Arch Linux
          /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem  # RHEL/CentOS/Fedora, Amazon Linux
          /etc/ssl/ca-bundle.pem                             # SUSE/openSUSE

      EOS
    end
  end

  test do
    require "openssl"

    assert_path_exists pkgshare/"cacert.pem"
    assert_path_exists pkgetc/"cert.pem"

    system libexec/"post-install", pkgshare/"cacert.pem", testpath/"cert.pem"

    [pkgshare/"cacert.pem", pkgetc/"cert.pem", testpath/"cert.pem"].each do |bundle|
      certificates = OpenSSL::X509::Certificate.load_file(bundle)
      refute_empty certificates
      spki_hashes = certificates.map do |certificate|
        Digest::SHA256.hexdigest(certificate.public_key.public_to_der)
      end
      assert_empty spki_hashes & EXCLUDED_SPKI_HASHES
    end
  end
end
