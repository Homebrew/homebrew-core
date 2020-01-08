class Minidjvu < Formula
  desc "DjVu multipage encoder, single page encoder/decoder"
  homepage "https://minidjvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/minidjvu/minidjvu/0.8/minidjvu-0.8.tar.gz"
  sha256 "e9c892e0272ee4e560eaa2dbd16b40719b9797a1fa2749efeb6622f388dfb74a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ac5ddf434a115b421a2fd20645d09c690b559e7c135bfa71687d540f80e9dadb" => :catalina
    sha256 "6bb235aea08165b0a9d359f3813fa3e1760ff283697734761d9663fe1488a0fb" => :mojave
    sha256 "e86d9876389882d5cc6db29798566bc845584280a4fb4f5baf6226313a74dd6d" => :high_sierra
    sha256 "29966954c6c7ff78b48f41a31574369ed58fd9b52cea613891726e8cc444bffe" => :sierra
    sha256 "fd6b121a06139dc071c2f7fdcf4731d5becc93350ed92f760c0b11631a985d16" => :el_capitan
    sha256 "c008144fc38184c5a438ed120b5cd1a009d07b4a8cf759bfa58955b4b34f6e85" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "djvulibre"
  depends_on "libtiff"

  def install
    ENV.deparallelize
    # force detection of BSD mkdir
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install Dir["#{prefix}/*.dylib"]
  end
end
