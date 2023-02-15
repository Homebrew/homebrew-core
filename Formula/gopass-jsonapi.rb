class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.4/gopass-jsonapi-1.15.4.tar.gz"
  sha256 "d75b351813f12fcf6616f384070118bf15a26179939fa4cfd7abdf570a7468b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e7e67e20af760b13b18fe00e958318e5254b366358695467b0d059b30117875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97807096d029f496044e9b740c1e488970ac6e0a118141bab8fb2065cd55689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "024af8610f1692ce4446c0926fd7a8338e3e9b6a4a59fe42a822e565dbc1539d"
    sha256 cellar: :any_skip_relocation, ventura:        "1d382bb5a89624bcfcb0bf57e8b5fa19a4111e0cedb09dfc4cc1d2178bfd30f2"
    sha256 cellar: :any_skip_relocation, monterey:       "5c60e0b7d7d068dd8f0287e30e08b2d6a1337b9a5c64c4219a3817cfd384e283"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa27fc5dedb30c6202a88b41926e78aff64f1cc0d88b961b7d47363f36df413b"
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
