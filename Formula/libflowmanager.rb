class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "http://research.wand.net.nz/software/libflowmanager.php"
  url "http://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.5.tar.gz"
  sha256 "00cae0a13ac0a486a6b8db2c98a909099fd22bd8e688571e2833cf3ee7ad457e"

  bottle do
    cellar :any
    sha256 "b71b99087cdddbd75b4cc932c52f3f5ed826ae019863a8d512570a847bc28e0f" => :sierra
    sha256 "aa68f7f79671aca71837840606be729da65803d56904a2712034a1ddf44516c5" => :el_capitan
    sha256 "cc62e753f86b63f2f0d547eb23b364d8f7df3d5b67d9826f53b7233ed3a64538" => :yosemite
    sha256 "f28480a77bb774599e0eee240195b1b6543c04f23912c666c593da6e51aa4316" => :mavericks
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
