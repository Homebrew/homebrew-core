class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "26129b41107c1057d3aba0edc6921971419974b929ae0136998aaadd66470fd3"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "105a04ab5305ac25d30e005f601ec56050221d960fa98f860741b9d2d326dff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244380d9b2ca7780603ee1e1e8bf3c15f84464ab21d44d7718c857badce2c8ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95cf08422d6faddfd98b331fe657ba0341c81652b8523ffa29d4f1ae319afb3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cffe17e5e9435b3231212ed0d9d830c0b7ddcd7ebe10e76b667253d3c594757f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b36d065bed0c3a2b87198c0cf791cfc558a7d16dee0459e299fca1b8019b88e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1122ac723da7413e57db98d5aef83c587769acbd2b6119a6ad5e09f3c78e39b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
