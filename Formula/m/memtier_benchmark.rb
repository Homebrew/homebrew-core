class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/redis/memtier_benchmark"
  url "https://github.com/redis/memtier_benchmark/archive/refs/tags/2.5.2.tar.gz"
  sha256 "a3667000d14d3226dff234d4d215d304d3ccd42e960e14dd7225efe1dcb6bbd0"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "705b113657eba372349cc0bc4a8247ac1657af0c60fc26f7c77d7b5d2062e900"
    sha256 cellar: :any, arm64_tahoe:       "4de4357f63724d5198bad0da24df2768550b2f8b7eac317dceb99894edbe854b"
    sha256 cellar: :any, arm64_sequoia:     "fac3ae4ef2b4ba88c07f77ce9aecb94e62ab9b23092723bed7e4260a87b0c719"
    sha256 cellar: :any, arm64_linux:       "90cd75974c98f86c48b0067f49021ecc20ca8a26601f8d0064fe2083fb643e7c"
    sha256 cellar: :any, x86_64_linux:      "11ede46ebe29cda797a703c8ad27eeb6a694c44c8a9975d980adf26f38016d16"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memtier_benchmark --version")
    assert_match "ALL STATS", shell_output("#{bin}/memtier_benchmark -c 1 -t 1")
  end
end
