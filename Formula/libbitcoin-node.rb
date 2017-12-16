class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.4.0.tar.gz"
  sha256 "578c865d0b11ee15ca74e47b54cdaf521839cf0846c91f9cb21da2d6a82ca1ea"

  bottle do
    sha256 "25a20a4acf17095fd1f7057a299a0f6c08db0c34bea18b2d0205bd638aa98fb6" => :high_sierra
    sha256 "ec6ce5313c0c1cd4dffe79224d9eb088a8ac8b074ac0a6b8d0ea87b9b18c3dc4" => :sierra
    sha256 "c9fbaabab9082a83ea3332a22757f2625ad374c7f6c6231c8bd505f9f21760b7" => :el_capitan
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
