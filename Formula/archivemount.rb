class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "http://www.cybernoia.de/software/archivemount.html"
  url "http://www.cybernoia.de/software/archivemount/archivemount-0.8.7.tar.gz"
  sha256 "47045ca8d4d62fbe0b4248574c65cf90a6d29b488d166aec8c365b6aafe131b6"
  head "http://cybernoia.de/software/archivemount/git"

  bottle do
    cellar :any
    sha256 "fa79260625aab463bb9093605237577f71832651254e547e7d5ba648f1c1ec3d" => :high_sierra
    sha256 "b1f2b88dc1a2c1681e8687f7f61eabda57541a2d8a83eeb595da573c32cbd5bc" => :sierra
    sha256 "2d9f116a2a8f5291ead663d5945f9f15fe333ac7e6bce608737c0ed426b431f7" => :el_capitan
    sha256 "0233a0eb88924591ce01e5a947a21c4acbdb57f539bc34de6ffbf3c87238b686" => :yosemite
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
