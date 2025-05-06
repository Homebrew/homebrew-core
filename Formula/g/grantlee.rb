class Grantlee < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://github.com/steveire/grantlee"
  url "https://github.com/steveire/grantlee/releases/download/v5.3.1/grantlee-5.3.1.tar.gz"
  sha256 "ba288ae9ed37ec0c3622ceb40ae1f7e1e6b2ea89216ad8587f0863d64be24f06"
  license "LGPL-2.1-or-later"
  head "https://github.com/steveire/grantlee.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "7821ba762af4dd4005b8c82ef9f2d3cbb9b03ad5ad67823ef92c9c6e8b249d48"
    sha256 arm64_ventura:  "cd51401e55656ade5d8842df92957a6af33ea3d3da309c418d0dd3b9c360e85d"
    sha256 arm64_monterey: "c48770f2d0dd9d96cff5f935f24da74cbba4bc03711803d86ca43a40bdb74d74"
    sha256 arm64_big_sur:  "deb426bef80bf69b2ef4a52b9aeed26283400f6d7f6ebe6d495ae43c2ba647d3"
    sha256 sonoma:         "2d20f5ad54f10d012824ec81eb04b032f0be388e088741fc4e64eb382232142e"
    sha256 ventura:        "afe7f2fb56c25ea01712c69806e5e6c91bfbc495604f254ff10443ceafe46334"
    sha256 monterey:       "ac395abc45412eca0aa6e5292127b6655f45ff4785d8d69457bc9f124f87f222"
    sha256 big_sur:        "cb83e418903303323e40af6f902331b1365ecb31382fc7f7407753a1533d0a0b"
    sha256 x86_64_linux:   "9fa1fc4626d293531c6a3823ed4124b114a5f823a58753731cdc4fd3c008271b"
  end

  # From https://steveire.wordpress.com/2022/11/11/grantlee-version-5-3-1-now-available/
  # > The continuation of Grantlee for Qt 6 is happening as KTextTemplate
  #
  # Just deprecating with replacement message due to incompatible API.
  deprecate! date: "2025-04-03", because: :unmaintained, replacement_formula: "ktexttemplate"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build

  depends_on "qt"

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
