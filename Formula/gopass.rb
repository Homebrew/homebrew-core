class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.9.2/gopass-1.9.2.tar.gz"
  sha256 "1017264678d3a2cdc862fc81e3829f390facce6c4a334cb314192ff321837bf5"
  license "MIT"
  revision 2
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e2cc18686045acfcf6cc0424a237071ee6aeb81cfe302b80729f332a83ee4d6" => :catalina
    sha256 "68c7593ac0be95ff5ec863b416baf6082d4c05600bb957970ecbda99c01a5f2c" => :mojave
    sha256 "2afb342f13e4a3f9e61783af3cf01720c75d4fdbe372e3910c99ec514ffe0884" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gnupg"
  depends_on "terminal-notifier"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"

    output = Utils.safe_popen_read("#{bin}/gopass", "completion", "bash")
    (bash_completion/"gopass-completion").write output
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

      system bin/"gopass", "init", "--rcs", "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/".password-store/Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
