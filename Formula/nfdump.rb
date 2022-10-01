class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.7.0.1.tar.gz"
  sha256 "d7c4b400f506bee1b0f0baecb9285bb7230588f0afa050bb898d5d48454b1632"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "70a059b159cffdc2779052d3208875f7d5ec3cd1011934ad5fefce8e784dcd59"
    sha256 arm64_big_sur:  "d5261036eec525b54b3e085523fdc12b7fbf22d2db547de517587db776c3e050"
    sha256 monterey:       "a53609defd554e191bd83c62959a0ad30214bad155df4dbec93cd63fe6a11b5f"
    sha256 big_sur:        "7131ea67f9eea20c42a56305b4c2464ef35a6ab7282db4d9f3ac991c4f8e41ad"
    sha256 catalina:       "51601b61506d7535d5253ad3690fd21cc931390dcc7a751d0f83a8b7a4fb5cd0"
    sha256 x86_64_linux:   "fe4f57703ca2c02d1035b2cbed8c08ba7a08b490e7a9122994abf0c38fceaa86"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--enable-readpcap", "LEXLIB="
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
