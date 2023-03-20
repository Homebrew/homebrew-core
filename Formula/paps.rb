class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/v0.8.0.tar.gz"
  sha256 "8fd8db04e6f8c5c164806d2c1b5fea6096daf583f83f06d1e4813ea61edc291f"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e3326fb171dfcd3f5a36a90549d48eac049405952eede125f920996c007b7fdf"
    sha256 cellar: :any, arm64_monterey: "6ed29020cb058bab185f934c04a3e4adc08f8e36ba4859c3db9aadf3a4bb3a32"
    sha256 cellar: :any, arm64_big_sur:  "15d0131e38f17ba32c9778d03ef3323f86fe205082fb72fdb66ecaa7e4a2dd52"
    sha256 cellar: :any, ventura:        "6458c23bcde24b31b736ef9b610b4adb824edc09438bd94e3ca14e00efa0b6c0"
    sha256 cellar: :any, monterey:       "eb7e80f53f60756a9c1153ef1d52832c78c942f40d42b1c2c789e4a44fa4a57f"
    sha256 cellar: :any, big_sur:        "3a00997c25f0fb731bf76583d47b5b2680c255949ed5f2e8981e0a54a64134dd"
    sha256               x86_64_linux:   "08926b1df0c882015a3a40593dfefc5d8ac0cbace74afc832fb3399e465e12b2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "pango"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_predicate testpath/"paps.ps", :exist?
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
