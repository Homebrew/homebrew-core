class Dvdbackup < Formula
  desc "Rip DVD's from the command-line"
  homepage "https://dvdbackup.sourceforge.io"
  url "https://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.2.tar.gz"
  sha256 "0a37c31cc6f2d3c146ec57064bda8a06cf5f2ec90455366cb250506bab964550"
  revision 1

  bottle do
    cellar :any
    sha256 "46d8ddb5da597ac1d7d25dd2372477056c4e189cd88287a3dcda53580ae11fa5" => :catalina
    sha256 "f061db26ed448eeadfab56a3304637d2b93f776c86e5ef8054d54a9b3b945616" => :mojave
    sha256 "af4a9c5af114554137620129a8d2fdf834aebdd8e8bc44710db69f1b7df99910" => :high_sierra
  end

  depends_on "libdvdread"

  def install
    system "./configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dvdbackup", "--version"
  end
end
