class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "02197becacec15ff1b862ea7e1ddc283145b72fc8a212e98b87d02e6c0637c9b"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecdf813c5a4e7e27fde5d8e1727189448e6e8a2eb4b7c356daa533ed01f592d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb52e7e2b11192ce52998002336b9da842e24088bcac2a08ed3f2ceb2cf9f622"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "675ef978ba7ac5d2a4b0ecc5640dbbcb15e4ac11b4717b5bc76c722a9c90a806"
    sha256 cellar: :any_skip_relocation, sonoma:        "56ba0fe2560acb4ffbb00535a0d9ea4141e7cdffad552c1e07e4ed07e250b0e1"
    sha256 cellar: :any_skip_relocation, ventura:       "158535e46718d4b18645a9b910b86fbaf1538f05e225a3612247f63d5bea9c8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "747a56dbca0c06dc81b23c388302d2e14ba6d183df3a6e15f3810dc785329f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b569eff1a9dd50d466e2a55ff7d36565e2fbe19888041a05c4f0b811a27a690b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository", output
    end
  end
end
