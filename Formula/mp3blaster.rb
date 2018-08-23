class Mp3blaster < Formula
  desc "Text-based mp3 player"
  homepage "https://mp3blaster.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.6/mp3blaster-3.2.6.tar.gz"
  sha256 "43d9f656367d16aaac163f93dc323e9843c3dd565401567edef3e1e72b9e1ee0"

  bottle do
    sha256 "8d7c349befa2a093cee2b1fea30ece26393069c19508defb4582a5f7e8200dda" => :mojave
    sha256 "da013614ce379f9037f2e6fc684adfe51918e40659577650a229dbd1c6f53847" => :high_sierra
    sha256 "6dd3817fae76ae7d928688836c580a46e0a6c2f3111507ea6c7a5ae17a1728a7" => :sierra
    sha256 "a9e7e56d97d45cd2e06819f15dedc2db738b70836a5897fb23a682202e2fb5b5" => :el_capitan
    sha256 "87ba8218ac7bceab2d0f388aae88e6c6a0f6dba2aad11b434d2370ab8ce8251a" => :yosemite
  end

  depends_on "sdl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end
