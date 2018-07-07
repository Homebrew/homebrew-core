class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.4.tar.bz2"
  sha256 "6099fad7b2b684e4eb716b1cb3fcac70baad5848e8643b0a39bade382a59acac"
  revision 1

  bottle do
    sha256 "1a0ad845512f003e9ff6e5030dadd2b55068416b20ff6752afb138ecec34bb90" => :high_sierra
    sha256 "384cb4c97464c5b9c4b1db5b41c03058de1b9d8512eba0e56741a02db886f422" => :sierra
    sha256 "5546cf02db9ff88afe5479bf8b694546ce538714145d67b70b3624e43367bcea" => :el_capitan
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
