class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+))\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "77b514e4f24993fdb1bf4f332f2552e45971f1aef49d348dc18f0fd4b84436aa"
    sha256 arm64_sonoma:   "1c1ef4b6949b00b43d737ba5e8ccf3e124fed1b494a0cfc65734d5e17612cebf"
    sha256 arm64_ventura:  "9ad07e45267b2d2a0fa26be01b173f83215d032e0bf8b69433088c7d417125a0"
    sha256 arm64_monterey: "76e51e0b9ba892fbb5878889350ea77fe937bd2e0c9818b9ae362725f401526d"
    sha256 arm64_big_sur:  "107f756e65f4e6951f09c2350e0d7f32d834f9b7bb4dd4b7a958da83031effae"
    sha256 sonoma:         "b436864802c7742341ad002bf0417bbcd3197c7f41ba06ebdc4299f562c209d6"
    sha256 ventura:        "17f1561b38270a60458f803772cae95dc8ec462f2e3635ac6a35281055c32e51"
    sha256 monterey:       "77c3625b281264e341610e3e10d1c90cf6227463283d905d42d812d1a4b02c71"
    sha256 big_sur:        "d2130d2129d4782859cb3f4a6eee800f3be0973be0c1db5b3292c84363eae807"
    sha256 x86_64_linux:   "e3c88be4b4e635db98f6b286f73e30858cd17e89e260ccd3aa2d892ccc9e5476"
  end

  # Move to brew ncurses to fix screen related bugs
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Using --with-screen=ncurses to due to behaviour change in Big Sur
    # https://github.com/Homebrew/homebrew-core/pull/58019

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--enable-ipv6",
                          "--with-screen=ncurses",
                          "--with-curses-dir=#{Formula["ncurses"].opt_prefix}",
                          "--enable-externs",
                          "--disable-config-info"
    system "make", "install"
  end

  test do
    system bin/"lynx", "-dump", "https://example.org/"
  end
end
