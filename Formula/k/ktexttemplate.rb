class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.25/ktexttemplate-6.25.0.tar.xz"
  sha256 "4e9f7583b3dcb37980b99fb2ac2de9e95af8b14fe9a166752bcb83c66ce26e25"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6efbf1f81e8e0a0a8938c51292a4c95cbf15dd1a5d7aac58a361d57fa8bd52ec"
    sha256 arm64_sequoia: "8381c2738e62b43095e9ee46c02849f55049ff8bb2adca17a68307c6c80014f1"
    sha256 arm64_sonoma:  "02ac5de4c16fefdbafa6625ff84044f062cea7ebbe59cc83f256aa19fa43e6d0"
    sha256 sonoma:        "f1044aca4d19ec346702e4a741d29268610ad634c7737b1d8c8a3ef926d98102"
    sha256 arm64_linux:   "0788b090069787d80c5bde1f7a0ae6f967ce4f2131e69193467b53a3053d7f6c"
    sha256 x86_64_linux:  "032659ae303fd6414c02615ed641279ff187d47e89b03595ee857ca7733aed35"
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
