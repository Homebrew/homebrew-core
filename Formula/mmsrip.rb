class Mmsrip < Formula
  desc "Client for the MMS:// protocol"
  homepage "https://nbenoit.tuxfamily.org/index.php?page=MMSRIP"
  url "https://nbenoit.tuxfamily.org/projects/mmsrip/mmsrip-0.7.0.tar.gz"
  sha256 "5aed3cf17bfe50e2628561b46e12aec3644cfbbb242d738078e8b8fce6c23ed6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b4578327661828737b3aa71615806ba6e2781d7c0815a12815023242ac80e598" => :sierra
    sha256 "cf0bc6b407f4861b174eddf55ae5da45330d37abc428013ca19f173d36a96d2a" => :el_capitan
    sha256 "07f4c9d5a84bb52e3c799ebe7c395a4939c0c7ac5dff0fb46e2ce84abd9b5417" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmsrip --version 2>&1")
  end
end
