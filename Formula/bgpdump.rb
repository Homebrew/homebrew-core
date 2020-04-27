class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://github.com/RIPE-NCC/bgpdump/wiki"
  url "https://github.com/RIPE-NCC/bgpdump/archive/v1.6.1.tar.gz"
  sha256 "abf52f2c50844b61dcac9fae74628e47cf3e854e1e2a62003e814ea8c3882950"

  bottle do
    cellar :any
    sha256 "2bfbd4dd9019c2cb8ae595a9e426faf477b8d00e6468745907666f36a5e4ee07" => :catalina
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
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
