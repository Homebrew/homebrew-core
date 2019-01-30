class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.42.2-source/maxima-5.42.2.tar.gz"
  sha256 "167e11d6513a65c829a35f24d4ba539bcd0a82fc3dc7a6721e4f9f118c67b64d"

  bottle do
    sha256 "252b0b5b0d355c288f85bfa403212431a7a0c7455f4f616cda5960657a676f74" => :mojave
    sha256 "557d50c32c4af36b4e0328678e57eccb5c90a4f926d47df1e9943821c933e90a" => :high_sierra
    sha256 "5ae7804b062b9bdaf3d8983e90f6370509558158ed5a7b5fec9e7ea9516be3bd" => :sierra
    sha256 "3a5894e1ff75af2e3bc1a6fdbb277bc17fa90d05f23d782f4c5b879dc6c9f48c" => :el_capitan
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gettext",
                          "--enable-sbcl",
                          "--enable-sbcl-exec",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
