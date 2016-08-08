class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p3/owfs-3.1p3.tar.gz"
  version "3.1p3"
  sha256 "81460ae8aab4a5cf2ff59bc416819baeacdeb1b753bc06fd09d6e47cef799be4"

  bottle do
    cellar :any
    sha256 "f3c9411be6ada67d8812d1989a588be032ff776db726c71a638662868de0d6f7" => :el_capitan
    sha256 "ef581bfe553455f79a5fcf93ca247f1d7ad0915e3854ad2a9885b8bac3515bcb" => :yosemite
    sha256 "6462c010b2307c488678673bec8772466baf7aafcb8917732f0606889ccadd90" => :mavericks
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
