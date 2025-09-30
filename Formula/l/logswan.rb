class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/refs/tags/2.1.15.tar.gz"
  sha256 "6e500f33b741fce766225048ec2197e57047f91baa42ecd55ec2b94cdc2c3b5d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30a337fd2c49156260471d813e013520c1313476d6c8a8d5b6ac933b3033cf55"
    sha256 cellar: :any,                 arm64_sequoia: "7723c48f946745fda128783c73682abcd538a34b87512f17ab7a48c2ec7d7b95"
    sha256 cellar: :any,                 arm64_sonoma:  "1c26389b0b04f97cdf2c79edd4ee731dd7660ae8565bbc02cc79b2818774258d"
    sha256 cellar: :any,                 arm64_ventura: "1706e833e83efa99e5376328bd2562b541661bcfd7b7b07e16c1632e983a82f8"
    sha256 cellar: :any,                 sonoma:        "e9c9114e2891d2c055a7ba55fc456b269082c11e32aadc7c894e8104b18c59cf"
    sha256 cellar: :any,                 ventura:       "397fd860ac0ce631568275746eab2407c2351c5c6cdf489e2363b64f7d996bfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d6c645f860d61304eafebf743fbfd4a2854c2e390bd9873c5e9defd8f917c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "339fb70c5c850f38feb2410126b57ea5b4b03e813aac818a28d2050ddb8c6f35"
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
