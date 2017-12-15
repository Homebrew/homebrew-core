class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/justwatchcom/gopass/releases/download/v1.6.5/gopass-1.6.5.tar.gz"
  sha256 "46e67203ed2862a69b3198682cd0090159c5268a8a80e80f496a38533c0cca85"
  head "https://github.com/justwatchcom/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21aa6338c51f527e4c22aabca629857d31a59a04dedee77634da7cb4d1b7c5e8" => :high_sierra
    sha256 "b453c3ffd658bb721abfa696053b9b10d5e6de8a8bbf9f5f5ffbd3d4efb3ca85" => :sierra
    sha256 "522f1ab0aba7125afa58883ed8ac718e64c997e3b0d6c95a74181943a3e432ea" => :el_capitan
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
