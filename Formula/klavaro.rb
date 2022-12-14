class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.14.tar.bz2"
  sha256 "87187e49d301c510e6964098cdb612126bf030d2a875fd799eadcad3eae56dab"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/klavaro[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "c69147ab8fcd4e71a00eaf69084b2d2f3cc8aaa4090f80a3ff6fb3ce446b7d76"
    sha256 arm64_monterey: "a961d4e3a5b19f56257c164d72795209975d95063710c2cca9bd01f2b33ca19c"
    sha256 arm64_big_sur:  "f8134898ced1370ca151f5ed12042f5ea38a527f715369b6e59ebc7b1500d616"
    sha256 ventura:        "372b9659f15b7984c9dcc9330c72cc6bdec43282f2a8fbc4997442ce8650a469"
    sha256 monterey:       "0cecac2787231738ec7e647f32f06171118d243c941160049611de7cc7cb0c52"
    sha256 big_sur:        "d6d1c7aaf96acb9061577df307bb98cb4d0b87e28b930d3a875b551d498d9f6e"
    sha256 catalina:       "76b1fc9787963e805dfe796c68450265d129797867bc1ac13a66bd489514cd32"
    sha256 mojave:         "886f52a4f91c189d2f5a3f9c68d2490842f0cb0d66f2d5d8b904b104c56fdf07"
    sha256 x86_64_linux:   "37086fa81be9f3d2e3dc31036a72bcc635e9db942107a1f012ec1c6cf1bc0823"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "gtkdatabox"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_rf include
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
