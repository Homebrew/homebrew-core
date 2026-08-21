class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/refs/tags/2.1.17.tar.gz"
  sha256 "47e2c80024a1abf4b3423446e65a520a5002e565a5488c14dcba87a80c820a2a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1235f842ff107dceeedcc34c5a3a7a207cb2e93aaae10673fffa6c42d6e94498"
    sha256 cellar: :any, arm64_sequoia: "60d33c244dcc8d051b0f56e2c7f0d7e8bd66f1a9a3197f1238127f3cc6d9a55d"
    sha256 cellar: :any, arm64_sonoma:  "9b1de7af7e98a4690a6ec8c20573181efe406caa7eb161a8e7372b8a3f3c0c2a"
    sha256 cellar: :any, sonoma:        "8c7f3ae7ed81fbe880c808deb28dee1a00e5958b865628a4928b13950dc91603"
    sha256 cellar: :any, arm64_linux:   "8d364756a6fe2544181e176be46c9d5e93c2367c31c0be6ef650034dfa6efe01"
    sha256 cellar: :any, x86_64_linux:  "db5cce8356236a6975da14b1111fcab2f1d2a993428be33fbcf681f0b7d25f98"
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
