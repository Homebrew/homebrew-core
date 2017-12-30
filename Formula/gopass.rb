class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/justwatchcom/gopass/releases/download/v1.6.6/gopass-1.6.6.tar.gz"
  sha256 "96be7ad9c1188d2880c3b9d676896b157d056621985a8784381b01429e660103"
  revision 1
  head "https://github.com/justwatchcom/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ee57df53c67adef2f266e9d4d3d08ea61135e6a42d049b22f440b518f3ee143" => :high_sierra
    sha256 "3cb3806e707901b8b91fc92f64ef6b7c40ddee8806ed843777be91f2dc4df745" => :sierra
    sha256 "7bd825344271ed78ca14cff6a111a1db53e306bae476ce9143ab1cc17e54f83c" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "gnupg"

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
