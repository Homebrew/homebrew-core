class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.4.0.tar.gz"
  sha256 "a2c88f463b85efe8c9b7617332759e9964dbe250273cb473ebbb479be2525ef5"

  bottle do
    sha256 "91da3aa386c5810c3ad34af991223a579ff7c7f5b77e143ce550b81884347148" => :high_sierra
    sha256 "4fd5c27fb1a24f27078bf4fdca964367f6ac13a3d5e5304d4aac8261b227114e" => :sierra
    sha256 "ffed49361044749f0a66aaaaa89b7599bfeef1ea3dab10543365eb70e482c804" => :el_capitan
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
