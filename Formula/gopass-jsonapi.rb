class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.6/gopass-jsonapi-1.14.6.tar.gz"
  sha256 "3ce434ee44c2cd17ac241bfc4a62e95d98d0e78e068f78a7d71106a4d555c6b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c35a5ea3daef4fc6bbb7d2ae2dfef05861b07ea032b50d1ea500c6d2572ae2d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b50f690b96d02955b21a0560e8170c4f2b76487fa3c80292db920f95c4601903"
    sha256 cellar: :any_skip_relocation, monterey:       "ba4b599c58d448200be7dbdc685803165dae336998fd4876466b36ecea75ebc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "deff313965167f86badccde5f6c3cdea636ff53bc357aae482fcee85992cb5ed"
    sha256 cellar: :any_skip_relocation, catalina:       "d068edfda75b548ff0b62ad80c639d9e1943f79007d8f71f9213abfa90440c50"
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
