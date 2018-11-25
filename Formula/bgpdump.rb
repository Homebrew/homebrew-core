class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://bitbucket.org/ripencc/bgpdump/wiki/Home"
  url "https://bitbucket.org/ripencc/bgpdump/get/1.6.0.tar.gz"
  sha256 "0a9f97ac79b6f093a54e39a6b952bd8fec7ca4d7352abf2509c464fdbdb2a79b"

  bottle do
    cellar :any
    sha256 "be587d92cf5ad81323a5054da8a9010c4ddf6740370c7158a3abd3a832475f02" => :mojave
    sha256 "fb3bbc75887e67758164e3ce55f6a4061442f195538349b0be86e17745134aaa" => :high_sierra
    sha256 "151caa6be8e75f495e3776d448364b096ba67c537a46264664e89b468eca7705" => :sierra
  end

  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
