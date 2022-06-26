class Classads < Formula
  desc "Classified Advertisements (used by HTCondor Central Manager)"
  homepage "https://research.cs.wisc.edu/htcondor/classad/"
  url "https://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.10.tar.gz"
  sha256 "cde2fe23962abb6bc99d8fc5a5cbf88f87e449b63c6bca991d783afb4691efb3"

  livecheck do
    url :homepage
    regex(/href=.*?classads[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:        "f9869ca00795efc9bcda53a12cf7d485bfceb6c373492f9d7d652ffb59da61d0"
    sha256 cellar: :any,                 big_sur:         "dcc6e15e209b41868d0e328ca0d65aac6416c923b494f53f1259ed97b64f4b33"
    sha256 cellar: :any,                 catalina:        "9803231cebf936ef95bd86c820a7f3ba832c56109ad8a527ac5786d1d6150234"
    sha256 cellar: :any,                 mojave:          "2c2987f20d62b7c0926071bfe5c2c9825b30b4c6dba4dd20e2d2f34c5369ef44"
    sha256 cellar: :any,                 high_sierra:     "febef9dc12fdea8d1dbd1687f835ac8a58d8a7534ce2a0735d6102872058ec59"
    sha256 cellar: :any,                 sierra:          "d51471a725a552974a309b8add05ca731264f7a0fbaedee1c85b97475c204cb7"
    sha256 cellar: :any,                 el_capitan:      "52bd3bb21e7a2491ad96f01988b802ab183c5e93d3123e9cc57b75e1a0076171"
    sha256 cellar: :any,                 x86_64_yosemite: "2ec01b2285391e8c1a696c783db281dc69c05e0f2c483792129799b8ad304d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:    "d6f5ea31c00944afcd4c2e3d78457d9f630ae17a4a58a161321c7c4c6b4046a3"
  end

  depends_on "pcre"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace.
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", "--enable-namespace", "--prefix=#{prefix}"
    system "make", "install"
  end
end
