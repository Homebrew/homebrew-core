class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.16/ktexttemplate-6.16.0.tar.xz"
  sha256 "1880cf1a890031dc6172513d3dfe78f38d5726184978220ca7142a3a6e40f9b5"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "d7998a9c467088612784c9ed2d44ce8d5b81b94b9dd7596d5782b8fdac797f30"
    sha256 arm64_ventura: "ea26cd88bc028d0bf7f03627b24691026e028eec6376f483ef225848c38a9348"
    sha256 sonoma:        "748f862da053db58762e55d71fd09cdfa659ebc240c6023ac309b803a6956026"
    sha256 ventura:       "5f6d4957a3718a9e6a1f442bcd610e103e2633bfac910ba43625d9ba1dc0dce8"
    sha256 x86_64_linux:  "834c985fcbafb4aaff57752ae8fdd606bfe10a70e468f9370a03aa7dcedf8378"
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
