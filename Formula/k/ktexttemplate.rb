class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.15/ktexttemplate-6.15.0.tar.xz"
  sha256 "5c652ebae5d32d1b84fa438ad94cc621621d31e0abcfef3b0a511a586d697a84"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "c9a5bc015dba350d97b73a2ab39160d461ddf4345dcfd2a239ccc69c63da5400"
    sha256 arm64_ventura: "387db45533821ac433ada224b063f666d4192744a5d6bae69bd0be89ce5bc03c"
    sha256 sonoma:        "32bdd38984ba1bc64949ab7b6bb2f8f44c357bdb51fea64ae576a81ebb61f6c3"
    sha256 ventura:       "4e80266c9dc4cc0aa70788096606b053be1fbc28faba08fca5b6d55c00db221f"
    sha256 x86_64_linux:  "c9f7ebe49aa6b966e075426367a1dac8d26edd51b0d99fb2259cfc86bc297e1c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qt"

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
