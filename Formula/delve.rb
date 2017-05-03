class Delve < Formula
  desc "Debugger for the Go programming language."
  homepage "https://github.com/derekparker/delve"
  url "https://github.com/derekparker/delve/archive/v0.11.0-alpha.tar.gz"
  version "0.11.0"
  sha256 "47278abc6928161cca902b203dab9351aa27428d82c4eefae23fc457781733f5"

  head "https://github.com/derekparker/delve.git"

  depends_on "go" => :build

  def install
    dlv_cert = "dlv-cert"

    File.open("dlv-cert.cfg", "w") do |file|
      file.write(%(
[ req ]
default_bits            = 2048                  # RSA key size
encrypt_key             = no                    # Protect private key
default_md              = sha512                # MD to use
prompt                  = no                    # Prompt for DN
distinguished_name      = codesign_dn           # DN template

[ codesign_dn ]
commonName              = "dlv-cert"

[ codesign_reqext ]
keyUsage                = critical,digitalSignature
extendedKeyUsage        = critical,codeSigning
          ))
    end

    find_output = `security find-certificate -Z -p -c #{dlv_cert} /Library/Keychains/System.keychain`
    if find_output.start_with? "SHA-1 hash"
      ohai "#{dlv_cert} is already installed, no need to create it"
    else
      ohai "Generating #{dlv_cert}"
      system "openssl", "req", "-new", "-newkey", "rsa:2048", "-x509", \
        "-days", "3650", "-nodes", "-config", "#{dlv_cert}.cfg", \
        "-extensions", "codesign_reqext", "-batch", \
        "-out", "#{dlv_cert}.cer", "-keyout", "#{dlv_cert}.key"

      ohai "[SUDO] Installing #{dlv_cert} as root"
      system "sudo", "security", "add-trusted-cert", "-d", "-r", "trustRoot", \
        "-k", "/Library/Keychains/System.keychain", "#{dlv_cert}.cer"
      system "sudo", "security", "import", "#{dlv_cert}.key", "-A", \
        "-k", "/Library/Keychains/System.keychain"

      ohai "[SUDO] Killing taskgated"
      system "sudo", "pkill", "-f", "/usr/libexec/taskgated"
    end

    mkdir_p buildpath/"src/github.com/derekparker"
    ln_sf buildpath, buildpath/"src/github.com/derekparker/delve"

    ENV["GOPATH"] = buildpath
    ENV["CERT"] = dlv_cert

    if head?
      system "make", "build"
    else
      system "make", "build", "BUILD_SHA=v#{version}"
    end
    bin.install "dlv"
  end

  def caveats; <<-EOS.undent
    If you get "could not launch process: could not fork/exec", you need to try
    in a new terminal.

    When uninstalling, to remove the dlv-cert certificate, run this command:

        $ sudo security delete-certificate -t -c dlv-cert /Library/Keychains/System.keychain

    Alternatively, you may want to delete from the Keychain (with the Imported private key).

    EOS
  end

  test do
    system bin/"dlv", "version"
  end
end
