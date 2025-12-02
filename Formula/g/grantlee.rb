class Grantlee < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://github.com/steveire/grantlee"
  url "https://github.com/steveire/grantlee/releases/download/v5.3.1/grantlee-5.3.1.tar.gz"
  sha256 "ba288ae9ed37ec0c3622ceb40ae1f7e1e6b2ea89216ad8587f0863d64be24f06"
  license "LGPL-2.1-or-later"
  head "https://github.com/steveire/grantlee.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "7501770536b91128b4cfc7bd84164137107e4c8b75832724519c59e09066221f"
    sha256 arm64_sequoia: "ff5f356d9d99d20848a315efc7e30a9046ab6534cd55a12ae8db0ba3ff86a1b1"
    sha256 arm64_sonoma:  "2a8a17b9478212757c2f73b9dc46f0db605dc8716088f5bbe11ba4eaa60efb98"
    sha256 sonoma:        "236c5ab7ebfa19ffc87cdeaf8105236760ad4ba5360ac4262512db9c66278d32"
    sha256 arm64_linux:   "059193ce399d602b74074c138f48b3853e633d7d105af82dadc986958c6cd811"
    sha256 x86_64_linux:  "74b014396908eb267076c314c1da3e6fc3780447b16a4b7d0bdabf0f5da7fc50"
  end

  # From https://steveire.wordpress.com/2022/11/11/grantlee-version-5-3-1-now-available/
  # > The continuation of Grantlee for Qt 6 is happening as KTextTemplate
  #
  # Just deprecating with replacement message due to incompatible API.
  deprecate! date: "2025-04-03", because: :unmaintained, replacement_formula: "ktexttemplate"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"

  patch do
    url "https://github.com/steveire/grantlee/commit/1efeb1cb61947e69b8c99ddbfc5b75cd27013a87.patch?full_index=1"
    sha256 "6c5fa321c5df2b970ec2873df610ec43dd2d50977cb0a104d0d7c4ecb90621c2"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DGRANTLEE_BUILD_WITH_QT6=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "--build", "build", "--target", "docs"
    (pkgshare/"doc").install Dir["build/apidox/*"]

    pkgshare.install "examples"
  end

  test do
    system "cmake", (pkgshare/"examples/codegen"), "-DGRANTLEE_BUILD_WITH_QT6=TRUE", *std_cmake_args
    system "cmake", "--build", "."
  end
end
