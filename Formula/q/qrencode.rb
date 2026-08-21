class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://github.com/fukuchi/libqrencode/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "5385bc1b8c2f20f3b91d258bf8ccc8cf62023935df2d2676b5b67049f31a049c"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 2
  head "https://github.com/fukuchi/libqrencode.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "52a9ea0465a3446c8b0930bbd7c0d5ac0c84c350992fe4937de39301758e2f20"
    sha256 cellar: :any, arm64_sequoia: "8f2cb82a0924e1d5b2ce0f5edbc59884bfb35b5ab8a7dae5a7b3f362679e278a"
    sha256 cellar: :any, arm64_sonoma:  "4f2202e6beb0a9526a4cda427da325a019a1eca2dcc60e6a3986c8221828a7da"
    sha256 cellar: :any, sonoma:        "3e025adbdbbab93dcaf86de897a088fc123ce3e950d7de7ca5feb61918286671"
    sha256 cellar: :any, arm64_linux:   "cca7bf38108300b9a5c9e0cec11fa387f789ca9191847a39e3a5fae13691858b"
    sha256 cellar: :any, x86_64_linux:  "cc915641ac9e2b18c6973ea1c1396b2aa5fe53b3ad21104b5ebe1dcd52b39f55"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qrencode", "123456789", "-o", "test.png"
  end
end
