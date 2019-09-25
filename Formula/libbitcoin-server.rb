class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.6.0.tar.gz"
  sha256 "283fa7572fcde70a488c93e8298e57f7f9a8e8403e209ac232549b2c433674e1"
  revision 2

  bottle do
    sha256 "89f68bb7f63d8607fedf7d43ef649cb9dea5e3aeed46de0761f3490ec6438e85" => :mojave
    sha256 "a41b76159482bb9e10e6a43f1b63ccbbdf9cd8330334918c4961a095a849d74b" => :high_sierra
    sha256 "be860f7ccc38400930cd9995a03e38f3ea3c3ce6d5fca54410941c92cd71c7e3" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-node"
  depends_on "libbitcoin-protocol"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    bash_completion.install "data/bs"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-server",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
