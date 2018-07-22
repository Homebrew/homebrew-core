class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.1.1/HandBrake-1.1.1-source.tar.bz2"
  sha256 "e3390c5fd901fb06d72e29c62a63d373d5fb5b3467295d114d815ae7b78a9d7a"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "e143886a0b8828b68b1560df985811d38cdf980aa411719d59a5d39794ccb256" => :high_sierra
    sha256 "10a69efc0815df7c540d40780d721b69a35810965fc2e0e90a0599c0cc2fb243" => :sierra
    sha256 "fafeee816388b23bd375ffa83f3a7e7051bc70b463a1a5b1db6a7e60e870abc8" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    # Upstream issue 8 Jun 2018 "libvpx fails to build"
    # See https://github.com/HandBrake/HandBrake/issues/1401
    if MacOS.version <= :el_capitan
      inreplace "contrib/libvpx/module.defs", /--disable-unit-tests/,
                                              "\\0 --disable-avx512"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
