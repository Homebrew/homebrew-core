class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "d317582bc6d00cba99a0ef01903a542c326c2a4262ef78a4aa682d3826fd14ad"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5102e0cf354692cdc217fd8ef1e07a8a1d1b75e3e317b77426cc9149e6a10a2e"
    sha256 cellar: :any,                 arm64_sonoma:   "8f97c5b13b85764dd830ddf34945a61bee5ea9e3f75e19abc8651ce710c7120f"
    sha256                               arm64_ventura:  "16b09472dc3bd572e592f5e9259757bec8e4b6a1879c1b8794387ad4b1fa9557"
    sha256                               arm64_monterey: "f93418e45de4ce25ab34c1f3d169ad78efe671418695004e97af7431d429481b"
    sha256                               arm64_big_sur:  "67c9775428fb88ce12557586ec8cf4e5247716b17fe79e8d24155d91e84cf665"
    sha256 cellar: :any,                 sonoma:         "544b52b5104d7299cfa8195c9a4104ca1a8e3087d5b674fcd6616aca2792f4e7"
    sha256                               ventura:        "4971627e0520e2e63cc3eddcf14cfdefe96b2b8561872770e39d143f2991484b"
    sha256                               monterey:       "548e67436072c1a9de5807fcdeeea64f44ebc5eb7a17720068ac137dafd0b62a"
    sha256                               big_sur:        "23c335f851dcd0f1c7b06ac29e9ea8e864dfbae66469c326efa237ea3bb51197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56adc9c14bfac95a6b2169fd0d190164ed77a405f2bdb1a89eb5929842748fb8"
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
      #include <bitcoin/network.hpp>
      int main() {
        const bc::network::settings configuration;
        bc::network::p2p network(configuration);
        assert(network.top_block().height() == 0);
        assert(network.top_block().hash() == bc::null_hash);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-network",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
