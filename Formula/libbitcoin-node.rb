class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.6.0.tar.gz"
  sha256 "9556ee8aab91e893db1cf343883034571153b206ffbbce3e3133c97e6ee4693b"
  license "AGPL-3.0"
  revision 2

  bottle do
    sha256 arm64_ventura:  "cc194f6874baa26fce10fb3b58b0ab520d0d6e3905f9fc21efaca2cc6f380393"
    sha256 arm64_monterey: "0fbb1c20470a60232647651c29ad41b547b8a162d5f6f59d64bacec746aa8a1a"
    sha256 arm64_big_sur:  "3ca1bcd8c32bfa5d8e3a5327d9f8358df52fecdf812fb3087de7892b6d0dec03"
    sha256 ventura:        "d2051f6d157cef0abe11c17b479e8c04f7f47b283412b76034a93b749f24249b"
    sha256 monterey:       "a5571bba28d70456ccc9305288dbd732026ab47c10617fee089a96edbaf04ec3"
    sha256 big_sur:        "9a5602620a3379a70257c8982f18c93b17de661201100e612e0c47276ad7b1ba"
    sha256 catalina:       "858904050abfa1fb52dfc0f4e2c3cd87938824ad41582d439c0d411817b00213"
    sha256 x86_64_linux:   "d1c90e07fdb6ffc78954bdba380dd7930a3acd243047a8f470a4f1a2fb792610"
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-node",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
