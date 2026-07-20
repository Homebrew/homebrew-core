class CaCertificates < Formula
  desc "Mozilla CA certificate store"
  homepage "https://curl.se/docs/caextract.html"
  url "https://curl.se/ca/cacert-2026-07-16.pem"
  sha256 "3ff344e30b9b1ed2971044eabb438a08f2e2245ddb5f8ab1a3ad8b63ab4eaf91"
  license "MPL-2.0"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?cacert[._-](\d{4}-\d{2}-\d{2})\.pem/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90e3eab7339e26e016ae74a4841fe569c4799c36fee2928bfb7bd55542fa791d"
  end

  def install
    pkgshare.install "cacert-#{version}.pem" => "cacert.pem"

    (libexec/"post-install.rb").write <<~'RUBY'
      require "fileutils"
      require "open3"
      require "set"
      require "tempfile"

      CERTIFICATE_PATTERN = /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m

      def capture(*command, input: nil)
        stdout, stderr, status = Open3.capture3(*command, stdin_data: input.to_s)
        raise "#{command.first}: #{stderr}" unless status.success?

        stdout
      end

      def certificates(path)
        File.binread(path).force_encoding(Encoding::ASCII_8BIT).scan(CERTIFICATE_PATTERN)
      end

      def fingerprint(certificate, openssl)
        capture(openssl, "x509", "-inform", "pem", "-fingerprint", "-sha256", "-noout", input: certificate)
      end

      def executable(name)
        ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).find do |directory|
          File.executable?(File.join(directory, name))
        end&.then { |directory| File.join(directory, name) }
      end

      def write_bundle(path, trusted_certificates)
        FileUtils.mkdir_p(File.dirname(path))
        Tempfile.create(["cert", ".pem"], File.dirname(path)) do |file|
          file.binmode
          file.write(trusted_certificates.join("\n") << "\n")
          file.close
          FileUtils.mv(file.path, path)
        end
        File.chmod(0644, path)
      end

      source, destination = ARGV
      abort "usage: post-install.rb SOURCE DESTINATION" unless source && destination

      if RUBY_PLATFORM.include?("darwin")
        keychains = {
          "/Library/Keychains/System.keychain"                        => "ssl",
          "/System/Library/Keychains/SystemRootCertificates.keychain" => "basic",
        }
        trusted_certificates = keychains.flat_map do |keychain, purpose|
          capture("/usr/bin/security", "find-certificate", "-a", "-p", keychain)
            .scan(CERTIFICATE_PATTERN)
            .select do |certificate|
              begin
                capture("/usr/bin/openssl", "x509", "-inform", "pem", "-checkend", "0", "-noout",
                        input: certificate)
                next false unless capture("/usr/bin/openssl", "x509", "-inform", "pem", "-purpose", "-noout",
                                          input: certificate).include?("SSL server CA : Yes")

                Tempfile.create do |file|
                  file.binmode
                  file.write(certificate)
                  file.flush
                  capture("/usr/bin/security", "verify-cert", "-l", "-L", "-c", file.path,
                          "-p", purpose, "-R", "offline")
                end
                true
              rescue RuntimeError
                false
              end
            end
        end
        fingerprints = trusted_certificates.to_set do |certificate|
          fingerprint(certificate, "/usr/bin/openssl")
        end
        trusted_certificates.concat certificates(source).select { |certificate|
          fingerprints.add?(fingerprint(certificate, "/usr/bin/openssl"))
        }
      else
        system_bundle = [
          "/etc/ssl/certs/ca-certificates.crt",
          "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem",
          "/etc/ssl/ca-bundle.pem",
        ].find { |path| File.file?(path) && File.readable?(path) }
        openssl = executable("openssl")
        if system_bundle && openssl
          fingerprints = Set.new
          trusted_certificates = [system_bundle, source].flat_map do |path|
            certificates(path).select do |certificate|
              fingerprints.add?(fingerprint(certificate, openssl))
            rescue RuntimeError
              false
            end
          end
        else
          warn "Cannot find a readable system CA bundle or OpenSSL; using Mozilla certificates only."
          trusted_certificates = certificates(source)
        end
      end

      write_bundle(destination, trusted_certificates)
    RUBY
  end

  post_install_steps do
    run "{{HOMEBREW_BREW_FILE}}",
        args: ["ruby", "--", "{{libexec}}/post-install.rb", "{{pkgshare}}/cacert.pem", "{{pkgetc}}/cert.pem"]
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
  end
end
