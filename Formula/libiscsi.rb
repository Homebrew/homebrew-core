class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.17.0.tar.gz"
  sha256 "788cf53f0d8f5f9fb4320da971d2fb49f9830c840bc74ed27cc72b6baa75dec7"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    cellar :any
    sha256 "225bd223bdfc8071e041665f39f0c64703eff9e048f9d51c92e5794439dfe5ca" => :sierra
    sha256 "fea641b8c29f1b3cb6d006608c1496d0863f03bb07d04a591a399bef987b639a" => :el_capitan
    sha256 "c416aa9d67d2df5ff3bdb45ed1a5caf0a0e3722d1092f80c5d8a6ff5f7b9ad8b" => :yosemite
    sha256 "56d4a1d0cfde3c5fe31410c60635b785ec23864f65f5ba0ede8354d205ba740b" => :mavericks
  end

  option "with-noinst", "Install the noinst binaries (e.g. iscsi-test-cu)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit" if build.with? "noinst"
  depends_on "popt"

  def install
    if build.with? "noinst"
      # Install the noinst binaries
      inreplace "Makefile.am", "noinst_PROGRAMS +=", "bin_PROGRAMS +="
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
