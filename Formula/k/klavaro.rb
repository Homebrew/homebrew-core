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
    sha256 arm64_sonoma:   "8f432b44af5316018f4fae547d34be57551f5a7488b1e93d3ef52f6b287da685"
    sha256 arm64_ventura:  "23667d36263cc2dbd16c0be5a4628b0d5b9b21f0282bfa9a48c207fd713fc89a"
    sha256 arm64_monterey: "d79e9d33e63f7bc74f5490e973cee657e7649069df4b4c0a557365ddcfce3899"
    sha256 arm64_big_sur:  "9be15accb0fef930088244748470938306d6cd52c86335a5f4b149f79608ba3c"
    sha256 sonoma:         "66b696fbc48083db308b614836da2a8e4a036d56560790b146645d4d74a0162d"
    sha256 ventura:        "8ab24479ec2c6b924c37d45605583e0f8f9a213a967ac2d28ad16a8ba1d159e5"
    sha256 monterey:       "1f8df6b3585c1c5b11512917c3345ab63097fb0802c27007b5706ee06f190723"
    sha256 big_sur:        "4ac2d5a091258fb5ae44d5883fc71f719446ff7df9e827b2b555b3bb7a850d77"
    sha256 x86_64_linux:   "ad2be44442da47138dd950ba6bad4701ba7db850fc1304fa7ad93aa1bd7d7284"
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
