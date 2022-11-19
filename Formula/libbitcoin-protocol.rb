class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.6.0.tar.gz"
  sha256 "fc41c64f6d3ee78bcccb63fd0879775c62bba5326f38c90b4c6804e2b9e8686e"
  license "AGPL-3.0"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f29aa2e8e18875c0142fd2c0f6c92b9801161c2d5aba1bbd5f2d41f04eaf5641"
    sha256 cellar: :any,                 arm64_monterey: "7edb84274d423491d9a08b123e41e58d8b5a9cc3a672453d4a85d79b32bbdd51"
    sha256 cellar: :any,                 arm64_big_sur:  "d4028de413f3f0ba181267d6a069ae68c266d28e7dd3fc2751bc95a304404beb"
    sha256 cellar: :any,                 ventura:        "9209fec88345ab55e73b1129e2ec94a02eacf672cd1aa7cf4db1bfb7c38645f8"
    sha256 cellar: :any,                 monterey:       "c67ae588036f05668243ec8a398e13f4d75e6f79fcab811dfd88480ace00ac11"
    sha256 cellar: :any,                 big_sur:        "b41eac4e335c9400111aaaef13b1673483bf0f0b6d73ce07302170fb449ddba4"
    sha256 cellar: :any,                 catalina:       "b6c185248d160d72d40da00e6731425bff8874fb888000f4b479a1a64dd7497c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ab31508a68eb374536d8545f101883c3898f16391e8b1f5f913dbb7617f0fa"
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-protocol",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
