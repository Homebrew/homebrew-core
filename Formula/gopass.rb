class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.2/gopass-1.12.2.tar.gz"
  sha256 "b4254ecbc14b62a68e1e98c99d08d53c50a5b5b15b8b5b592266a6d581c93f13"
  license "MIT"
  revision 2
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a794e1e56b2484bfdaf6e6c42f579671c5c31a73e000f2939aa6de37d76cae19"
    sha256 cellar: :any_skip_relocation, big_sur:       "6faa320d4c952d77c4414ce234bb26acfb211ab8852e45f220d07f15ab47662e"
    sha256 cellar: :any_skip_relocation, catalina:      "97fea77ce366596bba1b07ba953253622fb71d4346f231238f55e216436b6320"
    sha256 cellar: :any_skip_relocation, mojave:        "e74cf2edab933d91032ec2e8afdf1bc5a34373815ea3281abe00083322ce1150"
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
