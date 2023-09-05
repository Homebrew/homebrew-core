class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.8.0.tar.gz"
  sha256 "654aee258d7e110cce3c445906684f130c7dc6b8be2273c8dab4b46a49d8f741"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "3c587e28a40ccc268220b03f49db30c2bda7bc33804a7199c5d12e3eb3d39ca3"
    sha256                               arm64_monterey: "d354d235a093c9c45023844595f060185e66a96a51e5b34ee1a9e57919345f93"
    sha256                               arm64_big_sur:  "5ac648e724db6e394eb88bd1183027b9f08770e0ec12cbeba1843ff660f3b05c"
    sha256                               ventura:        "38b6d0a27c96288a0bf855fab65a2372e96dd3a473685d9a6e3f2d109447fff0"
    sha256                               monterey:       "704058e2ad64d8ee6b367aa079155ad854cd92fa0054e341f7e2ab5a4738748c"
    sha256                               big_sur:        "643c4eef9890fa62ee862f19892fc9fbb46f7ffd50eaaea1c0097adec9968b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe92a2d85f4c2aad06829a398e78b6f61b617f9c10b5ccceb94dbd87faeab327"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-system"
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
