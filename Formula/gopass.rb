class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/justwatchcom/gopass/releases/download/v1.6.6/gopass-1.6.6.tar.gz"
  sha256 "96be7ad9c1188d2880c3b9d676896b157d056621985a8784381b01429e660103"
  head "https://github.com/justwatchcom/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc1f4536345380bd9f51cc4e925e4cccd4aeb3e63675457c1d48fb54fd701fc5" => :high_sierra
    sha256 "07deb3469e0c5b1a62cf39e0055bfa9ec2c03bad701d1e5d78984fbe1689fc39" => :sierra
    sha256 "b7729cabc75f0b7cfc31417d496d2f21869cf09aeb216de3152227cfa3b1cbf6" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :gpg => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/justwatchcom/gopass").install buildpath.children

    cd "src/github.com/justwatchcom/gopass" do
      prefix.install_metafiles
      ENV["PREFIX"] = prefix
      system "make", "install"
    end

    output = Utils.popen_read("#{bin}/gopass completion bash")
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

      system bin/"gopass", "init", "--nogit", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/".password-store/Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
