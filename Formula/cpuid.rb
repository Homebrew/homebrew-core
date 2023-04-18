class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "66e5370b7f3c55e16ee72bf4d4f499421018e8e23fd1513a3f7ae23c0fb2785d"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8d434b82859717277686f679a9b221819bb1354ffd226eaef6def2c726804e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8d434b82859717277686f679a9b221819bb1354ffd226eaef6def2c726804e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8d434b82859717277686f679a9b221819bb1354ffd226eaef6def2c726804e9"
    sha256 cellar: :any_skip_relocation, ventura:        "2674d4af6eadd7cde86e70746dc7e9045f7afe7bd615cd6fa7ee5549dfe2ed8a"
    sha256 cellar: :any_skip_relocation, monterey:       "2674d4af6eadd7cde86e70746dc7e9045f7afe7bd615cd6fa7ee5549dfe2ed8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2674d4af6eadd7cde86e70746dc7e9045f7afe7bd615cd6fa7ee5549dfe2ed8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858f4ae7b941ae2259ac045080b7e6d3e08140a899a2a46e488c454419220ecc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
