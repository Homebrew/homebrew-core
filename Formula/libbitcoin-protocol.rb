class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.6.0.tar.gz"
  sha256 "fc41c64f6d3ee78bcccb63fd0879775c62bba5326f38c90b4c6804e2b9e8686e"
  license "AGPL-3.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "53f88eac4cf06ce839e7cd1015e59ea9cd2c2d5a68f25d95d949a07966879f6f"
    sha256 cellar: :any,                 arm64_big_sur:  "aafbba752b3be4a662fe4e1c3ee2bc915d323a41b9e51ec1dcced932c4cf1d7c"
    sha256 cellar: :any,                 monterey:       "e572cf3381d4d6f6f93a59e5b772a054926a05b3420e60794ba9ab7b84893d6f"
    sha256 cellar: :any,                 big_sur:        "aace6881bbd222da139ac545f8c1f77be1d6515a48a9153e4d7e605d242006cb"
    sha256 cellar: :any,                 catalina:       "e04f1896d57ca53344e59c20372809419735fae379b3350cadaabc04a8c57780"
    sha256 cellar: :any,                 mojave:         "af7dbd9acf2a65efa468e14e4923d33a69605e8ace1d91f697acf399ab6a6ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7353cdeff1b5ac4341580e031078ac5bc454fbc37d4d3dc448fb48dc6d909894"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "zeromq"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost"]
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
                    "-L#{boost.opt_lib}", "-lboost_system"
    system "./test"
  end
end
