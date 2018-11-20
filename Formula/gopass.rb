class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.8.3/gopass-1.8.3.tar.gz"
  sha256 "18281e07de961b26b9cce7c907e811d567b0e599649f0dbe703ab108984275a8"
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2300e1baf820c6dbfb7de68274ac1dc9582da30239cfdffe15d5a462e5f0d9fa" => :mojave
    sha256 "21354925ae75528e4b828a3bd8576bbfc0b87a5d32f7fba3390239c2195bd93b" => :high_sierra
    sha256 "d3ffc286bdd3aea88c21a34aeba0dcbdb648648ad7c7bae81ef8c5544bbdcb61" => :sierra
    sha256 "ba11c53440e647a9b16bb90722387e408c6d728592a455a1a99d3de71654d91c" => :el_capitan
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
