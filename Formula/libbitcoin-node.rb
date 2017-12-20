class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.4.0.tar.gz"
  sha256 "578c865d0b11ee15ca74e47b54cdaf521839cf0846c91f9cb21da2d6a82ca1ea"
  revision 2

  bottle do
    sha256 "75facd99ac5138cd67b8124dc91cdfd8b876d900693fe6c6f4aed8828273bf34" => :high_sierra
    sha256 "f7b6ae188f3b3275c3e6085dc24111b0e976b0270d8150a0d7022c245fe1f753" => :sierra
    sha256 "e0f990911561abdb1557897c6ee2b6d9962eb0b1762332672d2012a78d8267cd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-blockchain"

  resource "libbitcoin-network" do
    url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.4.0.tar.gz"
    sha256 "3ef864289fc0085dd695f34e0a2dc8619011b3d6dbd7cffe1e19651ceff27ed9"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin-blockchain"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("libbitcoin-network").stage do
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
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-lbitcoin", "-lbitcoin-node", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
