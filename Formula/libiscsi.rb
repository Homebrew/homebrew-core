class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.18.0.tar.gz"
  sha256 "367ad1514d1640e4e72ca6754275ec226650a128ca108f61a86d766c94d63d23"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    cellar :any
    sha256 "5ca0c39a5aba32abddd1fdd4ffad754baa0d61380579fa1cd03c511e331a24a9" => :sierra
    sha256 "fb4e0bf29a4500377478c42476b9cf1c20f96fd1891397ed0fad499fe5555117" => :el_capitan
    sha256 "c89e40197b9aebd712c67d43fbe7a4e085ddb7a1b58861c6e98444271fd9e383" => :yosemite
  end

  option "with-noinst", "Install the noinst binaries (examples, tests)"
  option "with-cunit", "Install iscsi-test-cu, the iSCSI target test suite"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit" => :optional

  def install
    if build.without? "cunit"
      inreplace "test-tool/Makefile.am", "bin_PROGRAMS =", "noinst_PROGRAMS ="
    end
    if build.with? "noinst"
      # Install the noinst binaries
      inreplace ["tests/Makefile.am", "examples/Makefile.am"], "noinst_PROGRAMS =", "bin_PROGRAMS ="
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iscsi-ls", "--usage"
    system bin/"iscsi-test-cu", "--list" if build.with? "cunit"
    system bin/"prog_noop_reply", "--usage" if build.with? "noinst"
  end
end
