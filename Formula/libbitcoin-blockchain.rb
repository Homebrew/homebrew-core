class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.6.0.tar.gz"
  sha256 "18c52ebda4148ab9e6dec62ee8c2d7826b60868f82710f21e40ff0131bc659e0"
  license "AGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1f50e84c1b0143b39d7c5c4bc9335fa5dcd1ae111ea353f262ac87be739c95e"
    sha256 cellar: :any,                 arm64_monterey: "6e268a306e2d5bfc8c869583657f87478fd93cdfc1ff255c4a0abdb79b91c8cb"
    sha256 cellar: :any,                 arm64_big_sur:  "b7c44a2ed8989cacf465c1d894dbd751157a5fce582eaa59f98cae434c74a36d"
    sha256 cellar: :any,                 ventura:        "f6f2d541e925c411e334254e7df178b8eefa03c6d2ef519fbb58247b9f52c492"
    sha256 cellar: :any,                 monterey:       "a92a23c0de8dd7e9caf5c95fa9d9ec40eece1d53e8a188b84ad19c9c25545b52"
    sha256 cellar: :any,                 big_sur:        "f6923588781327e108f3f08bdfafdb89593379ed0c8ad74be0041d75784411f6"
    sha256 cellar: :any,                 catalina:       "f9c355a44e432ca45b1c7305c158e98d6fc9189f2b8969f32de9f42d1ba77125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96db923a7d219f33b9af9201ede759667f87c17a79ae6613b9d19c1000036771"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-consensus"
  depends_on "libbitcoin-database"

  def install
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
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/blockchain.hpp>
      int main() {
        static const auto default_block_hash = libbitcoin::hash_literal("14508459b221041eab257d2baaa7459775ba748246c8403609eb708f0e57e74b");
        const auto block = std::make_shared<const libbitcoin::message::block>();
        libbitcoin::blockchain::block_entry instance(block);
        assert(instance.block() == block);
        assert(instance.hash() == default_block_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-I#{libexec}/include",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-L#{libexec}/lib", "-lbitcoin-blockchain",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
