class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.3.tar.bz2"
  sha256 "3c0842ba6a7674c51b3bf1ba474dd3cdd2df9fbcd2147d3216fed2b613377397"

  bottle do
    sha256 "427c70d469e28a5ee2ac9dfec67610897b3eda93b65dc06e0c599e968130eafb" => :high_sierra
    sha256 "900785f6ed8a1df032b06ca6047871703fb0b3a8c7744eceeaa589f60bf9cf9e" => :sierra
    sha256 "1c25ab0cf4366d149611d8e29b613f1f4f827078427c5659dddceeb4dfd9440a" => :el_capitan
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
