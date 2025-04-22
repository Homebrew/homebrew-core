class LibbitcoinSystem < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://github.com/libbitcoin/libbitcoin-system"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "b5dd2a97289370fbb93672dd3114383f30d877061de1d1683fa8bdda5309bfa2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cb0bbe2d1b5692e930dcb817ed09fa8b1fa392ede7eab0dc856c2d6fa7017c65"
    sha256 cellar: :any,                 arm64_sonoma:   "3324919582f6ab687cbf681f056347985f63c06c7f525e0aa283dc592197a000"
    sha256                               arm64_ventura:  "aed49e03846e0be62e5e605ca01179ba431dfb35d3f1b844ff8fce859549862f"
    sha256                               arm64_monterey: "0a300abdc05543b90b2b5db0e0d6117ca3d8c97cce089349350435d169321525"
    sha256                               arm64_big_sur:  "346c920f79aca4136d57b17deee022f6d12938b9813b4ee90a5f41a1019d7ef9"
    sha256 cellar: :any,                 sonoma:         "8392a926e0bb32374ffea7d4253a32582a48d0289e01289c395b059d04317fa9"
    sha256                               ventura:        "60aea6392017d5e69d5a8c3474c3561929286300fe3b174eacad804669451523"
    sha256                               monterey:       "e93abbec391254c0b3687735eede748b0efd90426730f51fb30b6fa0838bc756"
    sha256                               big_sur:        "a4a7556454aee07df23327dc93fa861b9a7fc429577adbc3b7788ae8430262c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9f1a6063cdcb6c35a069eb546968520935ad2addcc25e4d76229dcc8b61806a"
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

  resource "secp256k1" do
    url "https://github.com/libbitcoin/secp256k1/archive/refs/tags/v0.1.0.20.tar.gz"
    sha256 "61583939f1f25b92e6401e5b819e399da02562de663873df3056993b40148701"
  end

  def install
    ENV.cxx11
    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--enable-module-recovery",
                            "--with-bignum=no"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

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
      #include <bitcoin/system.hpp>
      int main() {
        const auto block = bc::chain::block::genesis_mainnet();
        const auto& tx = block.transactions().front();
        const auto& input = tx.inputs().front();
        const auto script = input.script().to_data(false);
        std::string message(script.begin() + sizeof(uint64_t), script.end());
        std::cout << message << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{boost.include}",
                    "-L#{lib}", "-lbitcoin-system",
                    "-L#{boost.lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
