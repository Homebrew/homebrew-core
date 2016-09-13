class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.3.4.tar.gz"
  sha256 "ce99d58dce74458f7656a68935d7a0c048fa7b4626566a71b7f4e545920ceb10"

  bottle do
    cellar :any
    sha256 "1bb54e72d3a8f290d486713cd4ec1953432e79b7c4964747e0b731098dd2af8d" => :sierra
    sha256 "dd71b908b10272f101836046c1e229a3322f7624e9b1c3082cb46131e89325a4" => :el_capitan
    sha256 "324b372e226bec1e40245033688ebcf2abdefe80ef0ca7e514aede0f55e260cc" => :yosemite
    sha256 "7ffbef2ac12a0d4cd11309f84931964ea27698b15849a97072018e8a3a135a96" => :mavericks
  end

  depends_on "gflags"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
