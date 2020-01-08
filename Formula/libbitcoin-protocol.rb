class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.6.0.tar.gz"
  sha256 "fc41c64f6d3ee78bcccb63fd0879775c62bba5326f38c90b4c6804e2b9e8686e"
  revision 3

  bottle do
    cellar :any
    sha256 "4343509f2811743b2d412543a5c4c1cf376e53f93226057508dbf207ce4f50fd" => :catalina
    sha256 "5f4d9d3d93e9b1a1a2545f18fe39a1632b5e6c866a4871cc7bb09e47299a75c6" => :mojave
    sha256 "e14a8762d49543f065e6363334beb9ec65caa16a2d0b9bf86e1411095b14f05d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "zeromq"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-protocol",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
