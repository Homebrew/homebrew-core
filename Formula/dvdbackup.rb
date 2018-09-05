class Dvdbackup < Formula
  desc "Rip DVD's from the command-line"
  homepage "https://dvdbackup.sourceforge.io"
  url "https://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.2.tar.gz"
  sha256 "0a37c31cc6f2d3c146ec57064bda8a06cf5f2ec90455366cb250506bab964550"

  bottle do
    cellar :any
    sha256 "65cf4593546ec639bfc42a46d9f22a3e54ee8bc6496581c0cb15cb3678fecb3d" => :mojave
    sha256 "c1451c94d778d2096df258679da916279cc117642128196cb487ac67c4c58f01" => :high_sierra
    sha256 "b47019e2fbfd855f1658b3edef96bf5a6794e6d8d6a863278b4512e4490e7e51" => :sierra
    sha256 "5f2f6cffd99459f429f53731c03528972648816997818bb4b8ec9df0a96c4d01" => :el_capitan
    sha256 "ac8d01872e80f83bb7fa14134391da4ec688a6e54d8f57ad58d970c38284e983" => :yosemite
    sha256 "c786685f8d6a27cb8b9be5a709b0b96b7087a59ab09b0736d4f48439e475aaf2" => :mavericks
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
