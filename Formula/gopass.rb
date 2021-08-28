class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.8/gopass-1.12.8.tar.gz"
  sha256 "1c4fc907f02e4a339dda84935940b9cf96c33ea57c6ab1cad4ec624df0950696"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "823dfc644816ef2fc7e626c66efd26a016209bd3438f8fbd999a49e49ac7887d"
    sha256 cellar: :any_skip_relocation, big_sur:       "65cb95d79c8a8c1009a0d979f95d86b6056341c4fb0e494720bd6a66cc35e799"
    sha256 cellar: :any_skip_relocation, catalina:      "ebb5ca85bf0e77dbf0c190284af761d72dca45f1793b0eb9308c89590a7b41b2"
    sha256 cellar: :any_skip_relocation, mojave:        "1963278d5865ae0039fe2409918e7b7370992452bc5423ba8ac47ccdd21e9216"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
