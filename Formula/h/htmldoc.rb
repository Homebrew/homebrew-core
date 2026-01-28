class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/refs/tags/v1.9.23.tar.gz"
  sha256 "03cc7c0c2c825c3576350745a3c9a3644ca5a9282f5052602de2eceee0c4c347"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "b70afc8fea7f1dae9f701126342b2f6d0e9f14a2ddbc23f6e2af4d3e27203ee9"
    sha256 arm64_sequoia: "34ec6b59478d71030efe78a378324729c07f80793fbe85bb10a60f4cff53a7e5"
    sha256 arm64_sonoma:  "50983ac64886dc78c2d8d9bcb7db59443077734ffe3d95d8d7a3dfcacf23dccd"
    sha256 sonoma:        "6d9387725fb117bac2c1b1fad87198d07dc1d457348424f2de50ba0f90273a4c"
    sha256 arm64_linux:   "c66c45d948eddc8faa1b1b4db79a473994ff799d5eccffcee010f066bb00812e"
    sha256 x86_64_linux:  "02036033fe6c031041822eae46a0c67fe785def16c084cd710167bda9a5e5dc6"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", "--mandir=#{man}",
                          "--without-gui",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"htmldoc", "--version"
  end
end
