class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/v1.11.1.tar.gz"
  sha256 "3c1666cdbf78a73736b089c3188c06724de53a96e43cb1d82fedd7e9543c120f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b029bea2be7e8ac0019e06a5483a3593e6b741c0b85b69e99f3625bbaa1f10e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "866c68f3fd44e4245febcee728c110d2fd2651514890eb7b4a31e6c5e3d429dc"
    sha256 cellar: :any_skip_relocation, monterey:       "5ac1be40eec6bd6436c1f0ffc38fca10fdc1d4e57619d79dfbd6c395e8f2e44e"
    sha256 cellar: :any_skip_relocation, big_sur:        "57b58bc0327828830342b5268360f7f8b9c4980e3a07f1adac51d380f8241677"
    sha256 cellar: :any_skip_relocation, catalina:       "d8d10b1fb7fa79a18f6fa2949ce1bccc2582bd9628e46e43da34e56a5eedc4a1"
    sha256 cellar: :any_skip_relocation, mojave:         "9d9a8953da2f0777cef157a69c2784f46f3c5873fbb14f61dedffabce1074153"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
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
