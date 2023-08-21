class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.8.0.tar.gz"
  sha256 "654aee258d7e110cce3c445906684f130c7dc6b8be2273c8dab4b46a49d8f741"
  license "AGPL-3.0"

  bottle do
    sha256                               arm64_ventura:  "4ee9419560f3991033fc7977b4b1b9a197deb90830efef19747536a2814f3d07"
    sha256                               arm64_monterey: "aa558d64c9b046e5ae2a7d271533a30e3fd898429591978210649110ddc8c19d"
    sha256                               arm64_big_sur:  "55ea861126ebcf7607d9cd82c209e6ede5bd3f36902f47f4f74471185f1e5104"
    sha256                               ventura:        "1460be17264c4610beb15c19e60d27283f359e6e805c07b76177f400061c2386"
    sha256                               monterey:       "41b79e8ceeec9e83affdcfb8980f0626c00b1769f3d7d236109ee866c8c124fe"
    sha256                               big_sur:        "2add9dbb1ae40c821299924d43ad48cff33643ee1848f57941446b1d4d8fb6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266a10fa688b253db2c329e9e98235d983995dca088c365b25e060b5c427c4f5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin"
  depends_on "zeromq"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/protocol.hpp>
      int main() {
        libbitcoin::protocol::zmq::message instance;
        instance.enqueue();
        assert(!instance.empty());
        assert(instance.size() == 1u);
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-protocol",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
