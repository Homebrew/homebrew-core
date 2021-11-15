class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.6.0.tar.gz"
  sha256 "283fa7572fcde70a488c93e8298e57f7f9a8e8403e209ac232549b2c433674e1"
  license "AGPL-3.0"
  revision 7

  bottle do
    sha256 arm64_monterey: "31933d4007329e335a2c0ee577e031a2c92e8ce626bdbf406bc2abfe138bd7e4"
    sha256 arm64_big_sur:  "7efe8bcecf7a2d191790ed5ef7e7ed2035c5b21647c1cca030a485a20e1efbbe"
    sha256 monterey:       "3ab1368ac79efae623be1d5163ec7c40c76520b9cf66479a0cbce143fe05ce43"
    sha256 big_sur:        "14d83e9545bea5d9d4c6c794b0dca5b58d4e36c90773e1b82db2ce346cb8bce4"
    sha256 catalina:       "03a1363d1b924bc9ce0cbbb4aa080e1c71b66374d6dd8def2b03023bff6595cb"
    sha256 mojave:         "23a267d222b28729da3e7dfefe559aba8f97b668910e08ce33f4016b067d8dff"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-node"
  depends_on "libbitcoin-protocol"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"

    bash_completion.install "data/bs"
  end

  test do
    boost = Formula["boost"]
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
                    "-L#{boost.opt_lib}", "-lboost_system"
    system "./test"
  end
end
