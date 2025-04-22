class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "654aee258d7e110cce3c445906684f130c7dc6b8be2273c8dab4b46a49d8f741"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6764b79e7494c3d693c5d961230bf1adfeeff13fa453af700e2095200795af2b"
    sha256 cellar: :any,                 arm64_sonoma:   "32d61b8663e5fab859bee922db71b16ccdeab283690837513a432187a151e38c"
    sha256 cellar: :any,                 arm64_ventura:  "5be699a3d80e31a8eb398fa12a578e895f6c205a3a142e7dfb05d772c14e9106"
    sha256 cellar: :any,                 arm64_monterey: "742149127e38e37075f9781f33281a939216bc506574fd3cc93c7f45cf692516"
    sha256 cellar: :any,                 sonoma:         "0dfab6ce1f61c24a8382d91827cef7b2159bfc6a1ced7650ca122f74acd58dbe"
    sha256 cellar: :any,                 ventura:        "d4b8881f4efbffac9c05558a89779bdfced6bb15a7ab4b25ad3d4e38014a5d41"
    sha256 cellar: :any,                 monterey:       "edb6856e737a04bc92421a3520f35b9db06b234ec7aa0385b4e5fb26e66dff9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746249bddfec92921117988b74797a1bf4797bf954693fc36c04af6b6946bab1"
  end

  # About 2 years since request for release with support for recent `boost`.
  # Ref: https://github.com/libbitcoin/libbitcoin-system/issues/1234
  disable! date: "2024-12-14", because: "uses deprecated `boost@1.76`"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-system"
  depends_on "libsodium"
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
    (testpath/"test.cpp").write <<~CPP
      #include <bitcoin/protocol.hpp>
      int main() {
        libbitcoin::protocol::zmq::message instance;
        instance.enqueue();
        assert(!instance.empty());
        assert(instance.size() == 1u);
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-protocol",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
