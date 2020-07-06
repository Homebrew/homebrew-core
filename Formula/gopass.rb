class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.9.2/gopass-1.9.2.tar.gz"
  sha256 "1017264678d3a2cdc862fc81e3829f390facce6c4a334cb314192ff321837bf5"
  license "MIT"
  revision 1
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "26710a265c2f2adffdb3f34e8b15873f2bc17ff9fa06406190b40f8368190ff9" => :catalina
    sha256 "a3592f946209c38204bad19c033f3b386e2f227c92783f8f399fbe02eb651b3b" => :mojave
    sha256 "063a6aebae764af7440c411c527182911ba31b0a688fc413afc684719544df9d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gnupg"
  depends_on "terminal-notifier"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gopasspw/gopass").install buildpath.children

    cd "src/github.com/gopasspw/gopass" do
      prefix.install_metafiles
      ENV["PREFIX"] = prefix
      system "make", "install"
    end

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
