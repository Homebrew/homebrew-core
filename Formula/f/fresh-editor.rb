class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.59.tar.gz"
  sha256 "761ff8b32dc17bc9d3ac5e13123cc2582261665bf7073bd46e5b2cb16ab8394c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bed0f9404ed391b06526b576e941b1641d97de386d17004ae80b392219088aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e130884d736afe92cdf988ec57d73df07f5cf4919d6959481ba33bc16288e144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10a897aa690942ebb6ae81e20f2b5bfede980f430875f61d78f35512cf4d6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d487cc2745ed4aca02172017325d3448716c4fd22daaa6f03b6ca5ac88b3996d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95489fcab31fcd70bfce84813179c206f62210e1bc795026189bbea0d4141076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1715bebe5536646cdc135f7cf3fce43f2e685276a43351e4c01b199818ac26ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end
