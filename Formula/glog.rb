class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.3.5.tar.gz"
  sha256 "277846fa6ac3d569fed48c8e32191ffd286ca52b808f243c81a4a91a9f9ff113"

  bottle do
    cellar :any
    sha256 "ba281274fae4fe2d690ee8da9c2760127541766e7cdf8674f298adb8e1da9ee7" => :sierra
    sha256 "48f7420d05c130c6df1a507d217d472cf25ffaa670685a2d94c98fefe26c40d2" => :el_capitan
    sha256 "e088fb40a28364979695cec6318bd10b6d3d5d3ac7a5ead6c494bda6fb6b1d21" => :yosemite
  end

  depends_on "gflags"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
