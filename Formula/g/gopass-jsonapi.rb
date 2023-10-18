class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.8.tar.gz"
  sha256 "753b1628ab379dea0cd4b599939fb46b11fdc46af76d049e7addc46477bf593c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b433230cf2363e07e50d496b804607cd72c9ba2cd3ad54de1174b4c989467e9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62dc045602e90ae00c3451db8d9131ccf6f7f13da4969c712818a0104a51d924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fae49704230de1561bcba05b9ce45882cc5b65bbf56bfc913485b290309ff9a"
    sha256 cellar: :any_skip_relocation, ventura:        "d7ab7bd88ead1fabc6ceca36bea95aa0e03ccd0ace0233a4a724d53c97aa15a9"
    sha256 cellar: :any_skip_relocation, monterey:       "fb12bce8c366340839affc183e71f72193805beb94c0568bc7a42f44641b9bd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a742f55cef8cd630b24fa2a93f3945543c57c7f1918b102fa31ed5bbe8851fd7"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
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

      system Formula["gopass"].opt_bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system Formula["gopass"].opt_bin/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end
