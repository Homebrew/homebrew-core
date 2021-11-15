class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://owfs.org/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p4/owfs-3.2p4.tar.gz"
  version "3.2p4"
  sha256 "af0a5035f3f3df876ca15aea13486bfed6b3ef5409dee016db0be67755c35fcc"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "60b2cdf16ab634a941884f3053afade439202e030b20defb61371ff4bd666a50"
    sha256 cellar: :any,                 arm64_big_sur:  "62b0c429498ff8aef96aa05ec7e4502978b3d98aa289ff8283a27de41352b68a"
    sha256 cellar: :any,                 monterey:       "578554d18620a943b499b22046d97c9fc818ad1ebad6552484a4dec245c7ce0e"
    sha256 cellar: :any,                 big_sur:        "d1f522c35882921728f0bc27c62c0b3a9c225278729ecf3b30ea093c21a1cc4b"
    sha256 cellar: :any,                 catalina:       "659e132d059f5b07c1f53f7ebc8676edf732da7b36f4e85065a30fe616358f50"
    sha256 cellar: :any,                 mojave:         "f67044700191dc6becb4b768d2c89f8e6714411ec4182c8297edcf3d3eac1318"
    sha256 cellar: :any,                 high_sierra:    "1812f6546d6e6957fc34aefadb1ce83ab8c7995a4c9c67b85f0ff7ba4e7e381c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7081d7fe26ec46288fa5bb16f5404e9697f1c567dde4ded5e181f0b54bbb6b"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--disable-swig",
                          "--enable-ftdi",
                          "--enable-usb",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"owserver", "--version"
  end
end
