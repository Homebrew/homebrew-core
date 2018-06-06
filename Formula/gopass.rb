class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.8.0/gopass-1.8.0.tar.gz"
  sha256 "dba0e1d1a10cbaadceee18b84f363bbbf886ba52cd9c658f5eca35d37b2f3f75"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d43cd331798143ded5b3ca0398bd3fc899e3440c2f526eb8227aeac31d6dc62" => :high_sierra
    sha256 "15116df614f6143bd150deb20367b45a2da94fed263fbdd24feb9bdf57160c95" => :sierra
    sha256 "728c4009e4c942de79814e8fe49babb7b060d141d80b2a9a25da881fad36abbe" => :el_capitan
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
