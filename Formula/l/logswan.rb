class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/refs/tags/2.1.14.tar.gz"
  sha256 "689e9af1ba8f22443e6ed3480693cc3a3add68c296d8e535dffa641c0c25e459"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "974dab0839e9b27ff17ae06429f35afa70dca195987f113d06c97d8cb8f76809"
    sha256 cellar: :any,                 arm64_sonoma:   "32ae83eb50fa25acf2381bb182f42c54480fb35f2e059d6e68cf32bf8d072601"
    sha256 cellar: :any,                 arm64_ventura:  "34a5d3784442be907bb3f1cdea2a8db5761b6434bf95e388ee613c4975d70eb5"
    sha256 cellar: :any,                 arm64_monterey: "44cf0367927f113091cb1050d5a5c6dd55b26eafb4a1842dc370ae1e2a866267"
    sha256 cellar: :any,                 arm64_big_sur:  "8fcddaba23605ecaa144b219d4343247e0607cd5cc6d1eff0fdfb0d7ccdd01d5"
    sha256 cellar: :any,                 sonoma:         "045a9cf326ea5dea7a20f6124ee5adaa75677a2912bf4a4400cf71cb20c2c55a"
    sha256 cellar: :any,                 ventura:        "80e8dcb3297de3ed06b1eb8d5181475f6e50fc1274173407c05f4728af3ac0b2"
    sha256 cellar: :any,                 monterey:       "141f991b685894f9f98d943523450561054611b3d28136b77bb051e9e9a82d18"
    sha256 cellar: :any,                 big_sur:        "844db408c05246ded9307d94044800c96d7d8329911c5151075cbf9d2d232306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d49f9622084644cb992ec23953d51a13661ff48625a110dbf00a5895d628fbb"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
