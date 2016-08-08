class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p3/owfs-3.1p3.tar.gz"
  version "3.1p3"
  sha256 "81460ae8aab4a5cf2ff59bc416819baeacdeb1b753bc06fd09d6e47cef799be4"

  bottle do
    cellar :any
    sha256 "4bbba80e7555d4a7a92330c11d5a18807a8f38449f4dfde66181bb11aeefbaa0" => :el_capitan
    sha256 "759834472aef709a5b85cd8090a10b328ccebf9faf5d93c42ac8a2f0f60ecae1" => :yosemite
    sha256 "d7464e56d0d362d4dff9a301959a2f07a0618aab91ac89074805c42fa69b013a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owfs",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--disable-ftdi",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"owserver", "--version"
  end
end
