class Libopennet < Formula
  desc "open_net(), similar to open()"
  homepage "https://www.rkeene.org/oss/libopennet"
  url "https://www.rkeene.org/files/oss/libopennet/libopennet-0.9.9.tar.gz"
  sha256 "d1350abe17ac507ffb50d360c5bf8290e97c6843f569a1d740f9c1d369200096"

  bottle do
    cellar :any
    sha256 "4702cca034bb0b60b4555615664cc4aedee95c189f37e23e93013594f1dc9321" => :mojave
    sha256 "82232ab7a71481570e3119e119bc93ef29a9d553c11e16fb93f157c66a7dfe8a" => :high_sierra
    sha256 "c3447365aeb1a478b14b5a71b6ffd29a1f95754fb460ed6f618b55e2f958c227" => :sierra
    sha256 "de1cb9622ec3b6501236af7e66367bc5bbaa20dfb8e3ae328a339bea6d708bab" => :el_capitan
    sha256 "abcf105b630a05b8a7d26f1a0ba8defafcf31c0dc23e79c3a5f8a9a14878e6de" => :yosemite
    sha256 "cc3c5f62b47b334019035ab1f34f6f9e8b195f3ea37afa820d8b3dbbb4402eae" => :mavericks
    sha256 "d030037f0323aacbd2009a6ced3ad55af8b75dc9392a106bb60895c6746e4323" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
