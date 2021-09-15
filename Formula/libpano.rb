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
    sha256 cellar: :any,                 big_sur:      "b1cb70b0d3ec17309a8c71f4d30ead3cee9c72f4efd8d15b85c9a5821de6fea6"
    sha256 cellar: :any,                 catalina:     "07de3b8c00569f6d7fe5c813eec7e72708ee12022d85003a64c0959d87057a1e"
    sha256 cellar: :any,                 mojave:       "8ed168e1c4b45fdc7815d6c275c0831f3b8450481cbd6b8ff8654d84f0486cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4c9f6180154f15419ba4f2486eddd5f110098ebc3150b2007f867e9459c24b4b"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
