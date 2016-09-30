class Mmsrip < Formula
  desc "Client for the MMS:// protocol"
  homepage "https://nbenoit.tuxfamily.org/index.php?page=MMSRIP"
  url "https://nbenoit.tuxfamily.org/projects/mmsrip/mmsrip-0.7.0.tar.gz"
  sha256 "5aed3cf17bfe50e2628561b46e12aec3644cfbbb242d738078e8b8fce6c23ed6"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a960cf06f0de2c60642c759ac411d477cceab2e5e61a38a6632be0bfd329643" => :el_capitan
    sha256 "19c1e0c00c04c87607ef472ac7c8b4cad26e39fc81403391133ef56235ad456d" => :yosemite
    sha256 "d20d0cfa504c27353b2f57cb3b30df288ce65ebb9ea54da80a0141cb9913de62" => :mavericks
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
