class CaCertificates < Formula
  desc "Mozilla CA certificate store"
  homepage "https://curl.se/docs/caextract.html"
  url "https://curl.se/ca/cacert-2026-08-13.pem"
  sha256 "f66dff1bdf8f96060b8177976f8b7d9254bc89bc4db933d769f7384d28480bc9"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?cacert[._-](\d{4}-\d{2}-\d{2})\.pem/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "37f5c1413f65c05d86e1279d76699f5d27ad77f8126f5776db13f3d64ee3d010"
  end

  deny_network_access!

  def install
    pkgshare.install "cacert-#{version}.pem" => "cacert.pem"

    post_install = libexec/"post-install"
    post_install.write <<~'BASH'
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
        local fingerprint
        fingerprint="$("$openssl_command" x509 -inform pem -fingerprint -sha256 -noout \
          <"$certificate_file" 2>/dev/null)" || return 0
        grep -Fqx "$fingerprint" "$fingerprints_file" && return

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
    assert_path_exists pkgshare/"cacert.pem"
    assert_path_exists pkgetc/"cert.pem"
    assert_match "-----BEGIN CERTIFICATE-----", (pkgetc/"cert.pem").read
  end
end
