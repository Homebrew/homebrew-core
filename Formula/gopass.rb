class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.8/gopass-1.12.8.tar.gz"
  sha256 "1c4fc907f02e4a339dda84935940b9cf96c33ea57c6ab1cad4ec624df0950696"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09267405b3ffc3cdf2dc90152409c3dc1330a493c82f0a83970b764ff69800c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "3995f1758172162cd836dcfc641516cb42a31e2c6cfe8e495f244090731d1631"
    sha256 cellar: :any_skip_relocation, catalina:      "136f73775965aaabe467d683f9ca45c4822ee7f5d7982c3e263606ad174b95cf"
    sha256 cellar: :any_skip_relocation, mojave:        "24de14bdb7dd176ee50b8879ed1988673939994525e2ce73b3abbdc2a794612b"
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
