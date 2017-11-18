class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "http://www.cybernoia.de/software/archivemount.html"
  url "http://www.cybernoia.de/software/archivemount/archivemount-0.8.7.tar.gz"
  sha256 "47045ca8d4d62fbe0b4248574c65cf90a6d29b488d166aec8c365b6aafe131b6"
  head "http://cybernoia.de/software/archivemount/git"

  bottle do
    cellar :any
    sha256 "ea8ba60b9451893f0f2e10f8c985ce00cfd5f45dd054f8cb46b64a39411c9098" => :high_sierra
    sha256 "7999cff6e0bb57e80804a0c9076d2740a4ae8f480b9dd1f6e420e6206001ab47" => :sierra
    sha256 "2629b61b54bac6b65b9f9d5a2065d1fb87c6ebf4b2c4cbb67cd1665f9163cc22" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on :osxfuse

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
