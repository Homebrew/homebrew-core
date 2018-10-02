class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://www.cybernoia.de/software/archivemount.html"
  url "https://www.cybernoia.de/software/archivemount/archivemount-0.8.12.tar.gz"
  sha256 "247e475539b84e6d2a13083fd6df149995560ff1ea92fe9fdbfc87569943cb89"

  bottle do
    cellar :any
    sha256 "3003ff24d840602eada1d74a1d3c319b87090717594a89fa14941594d3bc6688" => :mojave
    sha256 "e5ec32c8e34385931fe8a9cbd97b02dbba56650194e8cf8d0bfae628132ca096" => :high_sierra
    sha256 "bbe1f730c843b49dbdf8fcb05822314eacec63535e5a13096bf672e4446bc0c0" => :sierra
    sha256 "0723ee2f777084e9ed749c996ef0f48dd68d55925a008ed4283902c814e5748e" => :el_capitan
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
