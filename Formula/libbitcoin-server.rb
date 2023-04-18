class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.6.0.tar.gz"
  sha256 "283fa7572fcde70a488c93e8298e57f7f9a8e8403e209ac232549b2c433674e1"
  license "AGPL-3.0"
  revision 8

  bottle do
    sha256 arm64_ventura:  "88cd9412ba4ba25d1234f342eaaba0240448783c420b9da55a60534ec2bf07a9"
    sha256 arm64_monterey: "4868aed6b0d00889b48e51756dc2c1e4dc83a84813121c0ae34bc9ba7b32b69e"
    sha256 arm64_big_sur:  "98c8f92377aeda734d266bab207245c01ebc9cf3dac2b3f7522f561aa8c3dfdb"
    sha256 ventura:        "2faa22142ff16be03d52ccbe3c819682e0427eccede453d1032a23ff501f45ee"
    sha256 monterey:       "eed7d99d4a8d2d99aae78790f15428c43434272ddafe624f44f277f7d9f69922"
    sha256 big_sur:        "f288f34e1f92e3dab7396b5a23129119c5be203f57e05531a99bdb72466e09f0"
    sha256 catalina:       "f91b158f0e650cd12dfc48afd2bfa9f3df331a2029397a1037cd05a8bc59cdd2"
    sha256 x86_64_linux:   "0036af164e55dc5ae5fa0e09f0a02c9bf553efc52757bd4d7b9f94290b99cfce"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-node"
  depends_on "libbitcoin-protocol"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"

    bash_completion.install "data/bs"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/server.hpp>
      int main() {
          libbitcoin::server::message message(true);
          assert(message.secure() == true);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-server",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
