class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.8.0.tar.gz"
  sha256 "49a2c83a01c3fe2f80eb22dd48b2a2ea77cbb963bcc5b98f07d0248dbb4ee7a9"
  license "AGPL-3.0"

  bottle do
    sha256 arm64_ventura:  "86822901903e146be4fb9399f903cf1059731f1d0a086500436d64dea831cbad"
    sha256 arm64_monterey: "9a33df34d698757e0b61ee039c11195ab1aeba642bb9b6c1c86a8c35f9e64a33"
    sha256 arm64_big_sur:  "4f7509df7d2794e50bd619601f325320aa74b2e1117ae2c69bf72c22974faf35"
    sha256 ventura:        "7235300573e4a21004a041919fed4fd315c049640009831d8bb22aadbd8d2d51"
    sha256 monterey:       "42bf7aa7ab02771e21eb738911c790770e6adee737bdc345d7be9f5944e2dc26"
    sha256 big_sur:        "16f460f7b71ba5b2aa3ffd22a2b462a3be06700689ea7c0f3916db7da0c83e72"
    sha256 x86_64_linux:   "6e805714d022543fb058f87ecf8c2d464bc65a186beb217117f1941c08b14d2b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-blockchain"
  depends_on "libbitcoin-network"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"

    bash_completion.install "data/bn"
  end

  test do
    boost = Formula["boost@1.76"]
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
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-node",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
