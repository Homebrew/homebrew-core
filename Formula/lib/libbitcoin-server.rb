class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.8.0.tar.gz"
  sha256 "17e6f72606a2d132a966727c87f8afeef652b0e882b6e961673e06af89c56516"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "b62af4658d5a5375d77ac181cbc738a1cd45a68eef07d2b35a3db0eff78dbdfd"
    sha256 arm64_ventura:  "71d1f57d2446328e535c521e14b1c4f027f369d49834a2485af0576df448c27d"
    sha256 arm64_monterey: "87c42ad4f2da45a0f62b101f0cfdd981098eb70ee437e31c81c327eaf1885290"
    sha256 arm64_big_sur:  "32e27907e71f923f2ecd8562b5e29b3055d4500faa66b0b11814276be2ccbf02"
    sha256 sonoma:         "6ae1bba8b575b18d3845a3d66e50bb078ff1eb0ce43f65e5ec7c27f4c7c53e42"
    sha256 ventura:        "f77c06804b9da714661c8707e2de9be98ab0d078780f26b4446239b90b3c8919"
    sha256 monterey:       "24850c05ded89e22c89801ad9ac3deca5e4f764ef6b208477d91d10b0b3bde05"
    sha256 big_sur:        "194c6a6061a86800d4617935976654e63c292b6f8dfeb5d3644cd6242d33864b"
    sha256 x86_64_linux:   "092e84e3154ec07e9ed1efcf143fb241b2d2473071632eeae6d274b060bb05d9"
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
