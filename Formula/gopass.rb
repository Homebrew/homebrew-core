class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://www.justwatch.com/gopass/releases/1.6.3/gopass-1.6.3.tar.gz"
  sha256 "50e3971125f4333e4af33b6fb3b33e3c028b0cca7c7c9929230ba3f0e110b94a"
  head "https://github.com/justwatchcom/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3da64a86caf12cdafd7dfd062eb15a455c91ca4c056132f9e9e852f414f91da7" => :high_sierra
    sha256 "74c51ded668ab6f1c4a13f099471ebae8bbafd00779297e05cbe7d3b91f1a059" => :sierra
    sha256 "4b8ffb3445624dfbf260327f1355d84a5d155809ece8e2f9bc5e3de54734f379" => :el_capitan
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
