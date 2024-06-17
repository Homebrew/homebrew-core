class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "17e6f72606a2d132a966727c87f8afeef652b0e882b6e961673e06af89c56516"
  license "AGPL-3.0"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "fd1942df520a583e95d6ad957bfa1e22922ea7c5716e5ca6ab3bb5194bb8c8ea"
    sha256 arm64_ventura:  "8ca606e26ec8127227ef7397f16886d84e79b459272fac5f4a1f7206f2019a4d"
    sha256 arm64_monterey: "3cd9b1de869b049995f5db8ecf2885c8b8b1f4e8511e1c067c868022812c80be"
    sha256 sonoma:         "920adcf91e6630683855a81d532478fcdf5915806607ee15433648b43c17c6c3"
    sha256 ventura:        "182667a8d5d2d523db0c4e4ce50da3b5f03c5c301823f4f503971e8fdcd4f9c4"
    sha256 monterey:       "7437aebdff9448085b44ff4a2de92dd228642b35af9c75cfb484c355f48e1d4e"
    sha256 x86_64_linux:   "f6962cd5d1c1b6d33e3ecd3f2a7f680ad6a985f2defc221db20fdad01d0e0553"
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
  depends_on "libbitcoin-node"
  depends_on "libbitcoin-protocol"
  depends_on "libsodium"
  depends_on "zeromq"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"

    bash_completion.install "data/bs"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/server.hpp>
      int main() {
          libbitcoin::server::message message(true);
          assert(message.secure() == true);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-server",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
