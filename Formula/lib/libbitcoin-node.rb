class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "49a2c83a01c3fe2f80eb22dd48b2a2ea77cbb963bcc5b98f07d0248dbb4ee7a9"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "af98941d96c71ee8c0c6f155e5cc1d1cb1a6fed85eae311a663671f0baf8fc4d"
    sha256 arm64_ventura:  "b77eab1650d04674e86c7b794bc0e96f70fffcb2549008bdba0f278c1aa4b589"
    sha256 arm64_monterey: "456c03407d6cb891359d728d6303b2d668bc1a1cf7cfe0d878874fc110b40a65"
    sha256 arm64_big_sur:  "c198ecbe4bcab7fafd39a9ed847abccd84f26c8b3de45ae11c13f7e8bd07341d"
    sha256 sonoma:         "904ab97f4921e3d7c5f68d7f6fdcb17a67d487d7e9d3ce8073b09fb276ae1e41"
    sha256 ventura:        "97e1d00dab5e9da0a73c52d6abffa612753d09117a31729fc31262c5d0e88c1b"
    sha256 monterey:       "6a12ab524605ea8714c35c49f037f54ce53250516d875e132b0c9efad8b1d40c"
    sha256 big_sur:        "4a38fdcc76528e657974a00fcd98cf80947cfdc4834af7fe5307c8b734eefd1a"
    sha256 x86_64_linux:   "1f8fc0a015f1ee935c9731a9d58940eeec0c9b5f641f2dad229e8c71f5c09f4d"
  end

  # About 2 years since request for release with support for recent `boost`.
  # Ref: https://github.com/libbitcoin/libbitcoin-system/issues/1234
  deprecate! date: "2023-12-14", because: "uses deprecated `boost@1.76`"

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
