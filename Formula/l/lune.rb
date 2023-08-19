class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/filiptibell/lune/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "235c26df94d7c7f1e8a4fa79f9a08b407841cc4477274b42b172828eaf67d1bc"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f83b8cb4f1e1f13b4f92eec6ffbbd35328bad11cea4326ce9c31297e1e5ef350"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69fd3189a226aeeab4ff594b94faabef00ffbdfe08d7214216d32eb520dd4247"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aa9f4ca0db60d6dca2f1b20807115b32608f15e62700a073c051ec5e4600d08"
    sha256 cellar: :any_skip_relocation, ventura:        "0d0846909637b2763ba6bc0f3e311848951f98a3540c167b0cec564c8d091e52"
    sha256 cellar: :any_skip_relocation, monterey:       "8b6a77a6690d83756def851b3fcb66df5cf1c0a1a8b7aacfbf5227af24ee5410"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8582cfdad44243e56f9b80cf080e9828ebbd46196b41326d09067486226336a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4e0ef9f59b40936fcdcd0b0aaefdd33bfcb76f290b778fd5026fd905dd70c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end
