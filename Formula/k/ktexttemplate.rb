class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.26/ktexttemplate-6.26.0.tar.xz"
  sha256 "8b84643c32caf58812fec5a910a1fb98865bc7f91e778af860fa98b79d0ff038"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "4ab4a4b3ea6ed61e0d654d186e283775556716b4d35e0c3cf6fa2916bf808bf2"
    sha256 arm64_sequoia: "a68a822861a029d93bfc7e942a956d07fdf25236e40bd279283909e4584d7273"
    sha256 arm64_sonoma:  "551d9805bc299c5d88fef1c0df6b81d71887bcacec0a60cf57ef75691754e3e2"
    sha256 sonoma:        "ff8ba0a9ec9ddda5756f8d0a01c2ce7d90c63c34f991e9b82d1d5a03e606b381"
    sha256 arm64_linux:   "1265c1be182d7cb476ed9fa2bf3ca47b1d022693df6a83a682be9aad4f63020c"
    sha256 x86_64_linux:  "a170c81d678823a04fadb9c8ad89d8e5366857131c4f61cb60ef4d7c048aa60d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtdeclarative"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system "cmake", pkgshare/"examples/codegen", *std_cmake_args
    system "cmake", "--build", "."
  end
end
