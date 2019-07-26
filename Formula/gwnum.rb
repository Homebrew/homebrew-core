class Gwnum < Formula
  desc "A multi-precision arithmetic library"
  homepage "https://www.mersenne.org/"
  url "http://www.mersenne.org/ftp_root/gimps/p95v298b3.source.zip"
  sha256 "dac67702e45689e058519164222b6a1f0b32d9e7c88049f7c59f9699174105f0"
  version "29.8b3"

  depends_on "automake" => :build
  depends_on "gcc" => :build

  def install
    cd "gwnum" do
      system "make", "--file=makemac", "release/gwnum.a"
      lib.install "release/gwnum.a"
    end
  end

  test do
    system ENV.cc, "gwnum/test.c", "-L#{lib}", "-lgwnum",
                   "-o", "test"
    system "./test"
  end
end
