class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "http://www.cybernoia.de/software/archivemount.html"
  url "http://www.cybernoia.de/software/archivemount/archivemount-0.8.3.tar.gz"
  sha256 "e78899a8b7c9cb43fa4526d08c54a9e171475c00bf095770b8779a33e37661ff"
  head "http://cybernoia.de/software/archivemount/git"

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
