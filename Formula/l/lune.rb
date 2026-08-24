class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "09d15b4380e5b02a3656939619e948e6d36d549a4adbb499c1de0707a143adbf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ff9627b17489f62f157d51eff318969dea9c4ffe9ae65292d93295101087f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b73b515eaa1a0594b019cf2f160dcc6d67248bab8ebf1db117bae45d1bf1b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55af112d3f5e0745c6be835804c4bfefddb6f1e398492976d0095325c29a0f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "db21862d0f523de06c7d01ded3b00b127430172daa6c6a91e1dadbfbce7af5dd"
    sha256 cellar: :any,                 arm64_linux:   "c1588be14a565d060dced9664a9e79832960239821be3a93e558494250d0a223"
    sha256 cellar: :any,                 x86_64_linux:  "4ef9dbe6167235e5e5c8b3e097bf2cd12556baa86bb6ca0235d10dbf765bd923"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
