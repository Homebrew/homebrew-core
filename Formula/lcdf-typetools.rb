class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.106.tar.gz"
  sha256 "503c3869f73a392ae0ba41e0fc4f7672e70e2d66e8a81f3bb183f495183fa967"

  bottle do
    sha256 "8d5eace9f1dadaa4a1b05d5d6a9a1a4dcb622371c4c727ba1ab88abf014a2f53" => :sierra
    sha256 "5195d35913f9c1bf338ce1176e7a01c3e0dec967c68f69691ae4bcf201889d6b" => :el_capitan
    sha256 "ebfc8ad02b619eea5860a58a96b2255437c6b769f22ffb22354da0d7aa782967" => :yosemite
    sha256 "07c5729e83fcfd149cacac02fd432f500e87cee4a645e15dd53677a3798eeeef" => :mavericks
  end

  conflicts_with "open-mpi", :because => "both install same set of binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end
end
