class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "http://mikmod.raphnet.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.8/mikmod-3.2.8.tar.gz"
  sha256 "dbb01bc36797ce25ffcab2b3bf625537b85b42534344e1808236ca612fbaa4cc"

  bottle do
    sha256 "e6c015e020d03997d3ccc9300c8a01100f66f33cbaf93f2d1c3f95c63b1f7ee0" => :sierra
    sha256 "21475a8a26d1f3821b39ef2eb9de78ff2468986f1b8f8d8cf0cfbeb6423dd6f7" => :el_capitan
    sha256 "7860621b85ca9f842f8f05f8aba4cbe1487af34d6c193270ef03aa0560d3a144" => :yosemite
    sha256 "2337f777efccccb0f56e8120192f2bd67824876a5242e7213feac2eb58f81321" => :mavericks
  end

  depends_on "libmikmod"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
