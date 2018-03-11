class LibbitcoinServer < Formula
  desc "Bitcoin Full Node and Query Server"
  homepage "https://github.com/libbitcoin/libbitcoin-server"
  url "https://github.com/libbitcoin/libbitcoin-server/archive/v3.5.0.tar.gz"
  sha256 "37ef8d572fb7400565655501ffdea5d07a1de10f3d9fa823d33e2bf68ef8c3ce"
  revision 1

  bottle do
    sha256 "923f0184b88f4f65294dca620a89802a2c6d7019069b23a3635095f67e724c83" => :high_sierra
    sha256 "d15d06f49c17dae4e06eae578178646816cf3b34a2f96c85f43628d11676bf90" => :sierra
    sha256 "da9449bb2e23980a881b443136b497f77abde1bace26415678bccd75cbce735b" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-node"
  depends_on "zeromq"

  resource "libbitcoin-protocol" do
    url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.5.0.tar.gz"
    sha256 "9deac6908489e2d59fb9f89c895c49b00e01902d5fdb661f67d4dbe45b22af76"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("libbitcoin-protocol").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    bash_completion.install "data/bs"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/server.hpp>
      int main() {
          libbitcoin::server::message message(true);
          assert(message.secure() == true);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-I#{Formula["libbitcoin-node"].opt_libexec}/include",
                    "-lbitcoin", "-lbitcoin-server", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
