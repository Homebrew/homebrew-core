class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "b27b0d13e5584eef29ecd5c91f4d13fad6338b1975672326dcea61f1760fc569"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "397a69fc098799502b38bb70106daaaf3434cb8a5b56dea941582291a5da5c87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9e5631f54ee410776a8305e789029e752c93febe8126c870f12e3316ea445a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39077ec1c6df3c30b755dc27b6619d98f0baed8cb0562906785c89a19e5ca37"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0e62557bd7486ac223ed20bb2ba879013461ef89759c5a91e47ea15607d1bea"
    sha256 cellar: :any_skip_relocation, ventura:        "fd02627db39c2acc6f9088789c79211ef58772b73e3387cbf4052f6b67c0da04"
    sha256 cellar: :any_skip_relocation, monterey:       "5b1e822cdee1fb1445ffea297b0bbfbbd62c329a4de9d2709d2e9ca75f0dab84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b14849e00bb85cac8c62cd9eb47c665b6a669b426bddb96b7a7e1ad2de55422"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
