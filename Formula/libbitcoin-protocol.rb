class LibbitcoinProtocol < Formula
  desc "Bitcoin Blockchain Query Protocol"
  homepage "https://github.com/libbitcoin/libbitcoin-protocol"
  url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.5.0.tar.gz"
  sha256 "9deac6908489e2d59fb9f89c895c49b00e01902d5fdb661f67d4dbe45b22af76"

  bottle do
    cellar :any
    sha256 "51f4db9e17425b7fe26654ac21ae5cb5648f84d2077908a1967df1b5ea13ebbb" => :mojave
    sha256 "30d447fe065bda74e416dcc7aba55dfeebf26e4716c2ff84533a1926d89c5917" => :high_sierra
    sha256 "282b99bfa3ba4a811853efe0446f050e0eab39dd05e2056bf9b01c186e88be6b" => :sierra
    sha256 "61a6dab774bd9ef3552d04783bed9e1bdf801e6145e9b5739d1391a1788e4d15" => :el_capitan
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
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-lbitcoin", "-lbitcoin-protocol", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
