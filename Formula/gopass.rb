class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.9.2/gopass-1.9.2.tar.gz"
  sha256 "1017264678d3a2cdc862fc81e3829f390facce6c4a334cb314192ff321837bf5"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c92ac3a7054b95a90d082513acfb6907ec3f94fbd06f069d0ca3cf6d45e75d2" => :catalina
    sha256 "3e51441d06b0dc3c07598696290dfed30d22a1a9c03104ee8530c71410ce2086" => :mojave
    sha256 "ec013a9f9a9f39856246cc16e235cac544fb88f7780f8ba52d9dd51c3f31b127" => :high_sierra
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
