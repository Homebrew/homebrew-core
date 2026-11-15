class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.32/ktexttemplate-6.32.0.tar.xz"
  sha256 "074a1616a41600b358e20c40cab16113906c2394600a4fdc62a22696cc3d4156"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "fffbb65e121cac61c87a9db484a2e4cb8f0a27891c3a501109b330ddc3ca74ff"
    sha256 arm64_tahoe:       "f9d3c9f3d4619addfb5c7acadd195df16e144096ab4bea1d4231ed860ade58ca"
    sha256 arm64_sequoia:     "4f215d4a27fcec3b26503b1f481ec271f457b97c662598f5dfc5adc3fec3fd0a"
    sha256 arm64_linux:       "4db62d401de6e246547554dec8ec1472e39bdb508a35ea565b4349df28fb566d"
    sha256 x86_64_linux:      "d7a51a475d23921646734fd8264026aacad06529959ba8e2ddf08fcd3c8551ad"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtdeclarative"

  deny_network_access!

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
