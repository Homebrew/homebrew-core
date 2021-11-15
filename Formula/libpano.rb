class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.20/libpano13-2.9.20.tar.gz"
  version "13-2.9.20"
  sha256 "3b532836c37b8cd75cd2227fd9207f7aca3fdcbbd1cce3b9749f056a10229b89"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d384b4a21347cea34a2fec5e6f360f06e066c175a09818eb9278356f2975f9a"
    sha256 cellar: :any,                 arm64_big_sur:  "62acefefae0a9e7773c8040bd41706263f85563dc6533ed922d2cf4ff565f7c2"
    sha256 cellar: :any,                 monterey:       "f3405fc554fc285e20958abb8dc920ac61a205bcbd03ab8eabde83b76c1e9a48"
    sha256 cellar: :any,                 big_sur:        "b1cb70b0d3ec17309a8c71f4d30ead3cee9c72f4efd8d15b85c9a5821de6fea6"
    sha256 cellar: :any,                 catalina:       "07de3b8c00569f6d7fe5c813eec7e72708ee12022d85003a64c0959d87057a1e"
    sha256 cellar: :any,                 mojave:         "8ed168e1c4b45fdc7815d6c275c0831f3b8450481cbd6b8ff8654d84f0486cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9f6180154f15419ba4f2486eddd5f110098ebc3150b2007f867e9459c24b4b"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
