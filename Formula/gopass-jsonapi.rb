class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.7/gopass-jsonapi-1.14.7.tar.gz"
  sha256 "15475190dadcab03e54092b66f460a65e4fe4a5ce6ef9914372c444d5803337d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c57b437302fd7a9e57794b01c10a30bae37df6559e99b88ee9a6caa5d00332a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f70216e767f44ca83881beaaf079627dc0faa27dfc6d3c7102f94c239620c939"
    sha256 cellar: :any_skip_relocation, monterey:       "258817a367e5c26e9d52f153e6da37deabe8997afbda63298be40815c53d34e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3463bc13a3c183d5cc7c993d0669c7a9748e151eb2c881ac2c1eecd111498a0a"
    sha256 cellar: :any_skip_relocation, catalina:       "653fc25b432eeef7646c72279db0777ca86ac42321827dc61e8ef4bc72ee9f00"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
