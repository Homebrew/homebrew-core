class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "f7d1df04fe66a173613a13d1b632062150cd63d08ed9299cc2560f519ed33e2e"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2580a47d32b5db7291a9efa169555635a153a350bf6f71230bf3dca3f77dfa44"
    sha256 cellar: :any,                 arm64_sonoma:  "102c5b2a3223fd8f117641e010393d65dc130d735935bd922f884935ca0200c0"
    sha256 cellar: :any,                 arm64_ventura: "3f58eeb1890c44433bc6d9f5d2ae6149d61e7c096b314a5db085e1f016fe0fd8"
    sha256 cellar: :any,                 sonoma:        "d2b137c45686e51add29a118e911cba1ccce6f5130bc3931bd1f18107388c573"
    sha256 cellar: :any,                 ventura:       "16fae0c19979d8231228f7a89e522e6d3b26d85ad2b4b04bf7f8d87d795a0eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02cc68a0eaba6773c36aa54c53ee077ee2f2279e628671a4dacb15c529e2a02"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--enable-readpcap", "LEXLIB=", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
