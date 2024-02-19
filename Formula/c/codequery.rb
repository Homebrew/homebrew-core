class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://ruben2020.github.io/codequery/"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c03b86f9f5a8f5373862efaef6bddd18a15e5786570a93f0310725ecc5d74ff3"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ae69fccdb5da96510efa80e8e0b4cd31807cb30edddc7719027cb0f1de1b1dac"
    sha256 cellar: :any,                 arm64_ventura:  "9f59131f416edb0ea4498d3aa1656f16590dfbdf96eaeb05caf78af2bb1068b3"
    sha256 cellar: :any,                 arm64_monterey: "bb3f95c24ffc4eebe84aa5372b4be40aba4757db186a92e44e0893cafe66fc2b"
    sha256 cellar: :any,                 sonoma:         "d3b4b2a6e3baf12390b60d92d25ee82bf5901fb07c3697e773594f6db1f72f0d"
    sha256 cellar: :any,                 ventura:        "50a7565ca82c3d9fe00209649ea2c93b4f3bff7328161ff0b654953fd6c3e6c8"
    sha256 cellar: :any,                 monterey:       "307b180775e296751c34c95639f27f7db96bd3ee048012cd39562901c74401d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf46250da3e374c38cd59329b166140ee77c7e68801e98ad930ed33b9c1a72c"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    cp (pkgshare/"test").children, testpath

    system bin/"cqmakedb", "-s", "./codequery.db",
                           "-c", "./cscope.out",
                           "-t", "./tags",
                           "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
