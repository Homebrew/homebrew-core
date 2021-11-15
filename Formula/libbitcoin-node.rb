class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.6.0.tar.gz"
  sha256 "9556ee8aab91e893db1cf343883034571153b206ffbbce3e3133c97e6ee4693b"
  license "AGPL-3.0"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d8105b34dcc8ab66bb6e1f251f03b9edf88b3c795262a15c9a908ee885641f53"
    sha256 arm64_big_sur:  "618362516d236aa0d42448d44f67ea2243cfb89413b863abc7fd21da9cb09c3d"
    sha256 monterey:       "8d2bf98d64c003834f484bda25d02adb31be35ccd8a14db7ca12662cb8c69ba5"
    sha256 big_sur:        "bbc1a8235a1f33d915be794610ed69f06407ea63d85843a5ae71c978688f6935"
    sha256 catalina:       "c2932309e38888270138f7ced8f07f5dfe4c924664a1c0d2ad4835206b75a323"
    sha256 mojave:         "3280108b6455d1d70d1af8288ad910198b63f9cfcc6bef5d55a61e3855eacb3d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-blockchain"
  depends_on "libbitcoin-network"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"

    bash_completion.install "data/bn"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/node.hpp>
      int main() {
        libbitcoin::node::settings configuration;
        assert(configuration.sync_peers == 0u);
        assert(configuration.sync_timeout_seconds == 5u);
        assert(configuration.refresh_transactions == true);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-node",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
