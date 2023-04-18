class Minidjvu < Formula
  desc "DjVu multipage encoder, single page encoder/decoder"
  homepage "https://minidjvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/minidjvu/minidjvu/0.8/minidjvu-0.8.tar.gz"
  sha256 "e9c892e0272ee4e560eaa2dbd16b40719b9797a1fa2749efeb6622f388dfb74a"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/minidjvu[._-]v?((?!0\.33)\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "985e67e5358157239fda57613e0b6384bb960b97f39a41664840593da23c75c7"
    sha256 cellar: :any,                 arm64_monterey: "bb4837b0b0e44a2778ae1cb381f55a4f2eb5af6ae274502e9e7a0d28089c112f"
    sha256 cellar: :any,                 arm64_big_sur:  "a0a735a5315eba83afe335cd152f428e292527df6a3d3c0ce06aecc29eb7efc4"
    sha256 cellar: :any,                 ventura:        "d1cfde8c870c6d0e421fefcf1e7e2fe2e69495bbc5185c886e19eaeb3ac7a40d"
    sha256 cellar: :any,                 monterey:       "8df5fe38e4981f6198634640163cd1da4abd52562e08973f1c1fded6b663277f"
    sha256 cellar: :any,                 big_sur:        "fee2aaa060b89cd006949111164d953b1da44d3f4367409cff38880aa175cebb"
    sha256 cellar: :any,                 catalina:       "ac5ddf434a115b421a2fd20645d09c690b559e7c135bfa71687d540f80e9dadb"
    sha256 cellar: :any,                 mojave:         "6bb235aea08165b0a9d359f3813fa3e1760ff283697734761d9663fe1488a0fb"
    sha256 cellar: :any,                 high_sierra:    "e86d9876389882d5cc6db29798566bc845584280a4fb4f5baf6226313a74dd6d"
    sha256 cellar: :any,                 sierra:         "29966954c6c7ff78b48f41a31574369ed58fd9b52cea613891726e8cc444bffe"
    sha256 cellar: :any,                 el_capitan:     "fd6b121a06139dc071c2f7fdcf4731d5becc93350ed92f760c0b11631a985d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d5e5eeb3d8e0c3cb1a327c12d0e633c590d683c6fd533a3fdd1758c54d3083"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "djvulibre"
  depends_on "libtiff"

  on_linux do
    depends_on "gzip"
  end

  def install
    inreplace "Makefile.in", "/usr/bin/gzip", Formula["gzip"].opt_bin/"gzip" unless OS.mac?

    ENV.deparallelize
    # force detection of BSD mkdir
    system "autoreconf", "-vfi" if OS.mac?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install Dir[prefix/shared_library("*")]
  end
end
