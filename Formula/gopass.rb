class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.8.4/gopass-1.8.4.tar.gz"
  sha256 "2a00263dd169b560c75572239ba341edeec8acb66518fdca33d55d81fb94fc9f"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5589d624a7d4087f6f54f2f78f8b5a16803acf762217a65e6d69eae0d4ddb0ef" => :mojave
    sha256 "92fecc68946782936b09d0a8b9a78961f0dafa35605a317cadbd0f58948e9b5e" => :high_sierra
    sha256 "e4b03e45da2ee61507c1e7a7780e298c8bb3d96743572b1e84d6b76339d89219" => :sierra
  end

  depends_on "go" => :build
  depends_on "gnupg"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gopasspw/gopass").install buildpath.children

    cd "src/github.com/gopasspw/gopass" do
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
