class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/justwatchcom/gopass/releases/download/v1.6.4/gopass-1.6.4.tar.gz"
  sha256 "c1f12206a7cbd9a0ca6dda4ae39dc124d69cc51a9be6ae37d914373bcbba81cb"
  head "https://github.com/justwatchcom/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e298d5d88089e7eed23ee3a82304ceeecdd17b0987bad1cd6b65a1a1dcd098cc" => :high_sierra
    sha256 "30cd3d039b8674724acb239faae92268f82a2476b2815554f0f6c1b8f88a9e7c" => :sierra
    sha256 "e2e3695d9f4817ce0a65fbf32326c88dc138bca6c1849a338456c7e43da0e95f" => :el_capitan
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
