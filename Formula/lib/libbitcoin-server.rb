class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.8.0.tar.gz"
  sha256 "17e6f72606a2d132a966727c87f8afeef652b0e882b6e961673e06af89c56516"
  license "AGPL-3.0"

  bottle do
    sha256 arm64_ventura:  "082bea2bfaedf6c6f3a4ee4a12645b75aedfced2341f513042a99517e06ab8d5"
    sha256 arm64_monterey: "4501c991f8f454465b21b3930538052899fd767cf831e5b3812cc8c918a04e4e"
    sha256 arm64_big_sur:  "e4a843fb4a7bdf3c06f10143d25d96a2715dfb96e160adbc703180ef6956c4c8"
    sha256 ventura:        "757d05c4ed7198ae2229d73e7ed777f5773883d6ba64b659e98f930765d69b47"
    sha256 monterey:       "14afab6b6ff11bc0bcc4022e3dbcd736d83fcaaa182ba743328d49478c3ef96b"
    sha256 big_sur:        "e06cc874112bc7a00e4f8ef8d64d85932678704d841aa506cdf7c1782e79f068"
    sha256 x86_64_linux:   "3ce85aab0f43c4a663cf955ea4b0375f3ce129fc921479d4434efca41c02192b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-node"
  depends_on "libbitcoin-protocol"

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
