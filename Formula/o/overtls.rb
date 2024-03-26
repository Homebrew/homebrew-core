class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "dc6dc6930f7762b71813fdde9c806dba91e8c717ff767cce1283bdbcc092aaaf"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3872de432acd790d9d3d1e9f58250ed0707a2ed2588848beb1cbd1e57551c92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55b114044f1253cdbb2d9bc41cc9e94837c4dd30e657371edd5d477323ab7e7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe623f2d9a1d126c30154f1f5e0f862c22991d63b797ceab2403f8ebbf7c233b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f92732e37b3269afb6bcd982f81580ae87dddf26e88a43c7fbcb171aade4ccf"
    sha256 cellar: :any_skip_relocation, ventura:        "e278fdb0bf3ec15a3e7aaaa2c7be65ae9edf86f5ec9e7806cfee574b442b4a3d"
    sha256 cellar: :any_skip_relocation, monterey:       "86d824c418afcbdac737104912f0fac657dbab7793f411fadf0d3687473a22bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa02c2f37524e6ca0f020e9851dbcd2aad6f7b2b9ce2bc31c3215418c3408de9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "kind: TimedOut, message: \"connection timed out\"", output
  end
end
