class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/lsdvd-0.17.tar.gz"
  sha256 "7d2c5bd964acd266b99a61d9054ea64e01204e8e3e1a107abe41b1274969e488"
  revision 3

  bottle do
    cellar :any
    sha256 "cf5b1b4f5291edca2f210f74f391a625c06ef930a00b769aee3cf46e8f2c217c" => :catalina
    sha256 "0db26707f1960dd5354f14e4ad779ad4a29e3066b124e0b11af0a179b3a36256" => :mojave
    sha256 "c106839fc9f9378eb0d72ada198a13e279d7ef5afd73bc8bcafd1e99566bf50e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdcss"
  depends_on "libdvdread"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"lsdvd", "--help"
  end
end
