class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0785360dfd4133b910df0e6dab4d2e35df9c6c975cd925ce2bd2bd414ed7505d"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01e713be6a99b904d1d7260f024e457845697b913d05f6dcc532aa9ada1d0a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fceebb6d07558e02d03cace254d46400cf04c785b5c8fbfc2415785c0ed9ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e08a1a22a12af18657bdec7fa4709062974589f816a697542aa8180fade737bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "559c1dfb45c8c290efebe2f7bb4ab5e6dcdf44933c98b858af1c894a475f4280"
    sha256 cellar: :any,                 arm64_linux:   "af50c8ed57d23abf95689b483c8dbe76b41c73a604d4490d00741fd36c8d3fad"
    sha256 cellar: :any,                 x86_64_linux:  "86bd764227ee420cb396a548992717c130c78ae3fa62dbd909e4a1a536ed2dc7"
  end

  depends_on "rust" => :build

  def install
    # Drop upstream's x86_64 Linux lld linker pin
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid")
    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid-hook")

    (man1/"pixtuoid.1").write Utils.safe_popen_read(bin/"pixtuoid", "man")
    generate_completions_from_executable(bin/"pixtuoid", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pixtuoid --version")

    system bin/"pixtuoid", "init-pack", testpath/"pack"
    assert_match "OK: pack \"skeleton\"", shell_output("#{bin}/pixtuoid validate-pack #{testpath}/pack")

    require "json"
    connected = JSON.parse(shell_output("#{bin}/pixtuoid connect claude-code --json"))
    assert_equal [{ "id" => "claude-code", "outcome" => "connected" }], connected
    assert_match "pixtuoid-hook", (testpath/".claude/settings.json").read
  end
end
