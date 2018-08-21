class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.4.tar.bz2"
  sha256 "6099fad7b2b684e4eb716b1cb3fcac70baad5848e8643b0a39bade382a59acac"
  revision 1

  bottle do
    sha256 "c7bc6a929811138840780586ef8959f50ae87d884a4b6bb60fcc6d52212a05cc" => :mojave
    sha256 "f39cdd5655d54fee98f26a5b4130e470aba254426b48207e079713ce57b8babd" => :high_sierra
    sha256 "32d96b54db8cc86fc6c81969a3265424cb2d8ffb9eabf45f6c0d370b5689df60" => :sierra
    sha256 "a01441fd221fb814ef647fadf1ebe2f7cc705bacb3d89845b2c4c02c24caf478" => :el_capitan
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
