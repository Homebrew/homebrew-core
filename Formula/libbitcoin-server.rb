class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.4.0.tar.gz"
  sha256 "a2c88f463b85efe8c9b7617332759e9964dbe250273cb473ebbb479be2525ef5"

  bottle do
    sha256 "11cc8c808a01e184e1127348688d29eb06d99f1778362e93e97b6d11186bb5ce" => :high_sierra
    sha256 "d935e269807765e46fc01000162e8a8ed429b6ecca616da51fbe33cdcc69e3dd" => :sierra
    sha256 "f030a6dbe681371685833a1cbcfaa322616319c0c900a6676840fe63338c3221" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-node"
  depends_on "zeromq"

  resource "libbitcoin-protocol" do
    url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.4.0.tar.gz"
    sha256 "71b1a5b23b4b20f4727693e1e0509af8a0db4623bb27de46e273496ada43a121"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin-blockchain"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin-node"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("libbitcoin-protocol").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/server.hpp>
      int main() {
          libbitcoin::server::message message(true);
          assert(message.secure() == true);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-I#{Formula["libbitcoin-node"].opt_libexec}/include",
                    "-lbitcoin", "-lbitcoin-server", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
