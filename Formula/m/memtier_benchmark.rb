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
    sha256 cellar: :any, arm64_golden_gate: "76936ff1606569a753f9650698ff8599f4e8e32824b1974cc49b313fd9c8b844"
    sha256 cellar: :any, arm64_tahoe:       "8c48b907c70f7ed7586c5d5c8c9bbf8f88b791f9d28863680b222f9682ba1428"
    sha256 cellar: :any, arm64_sequoia:     "3226ddd0d70c71f64158e54597a31aecfcce48ea9a29e8fe23f94330f39c6f6b"
    sha256 cellar: :any, arm64_linux:       "f6f38cd1747a6e0afae84873382c28d2b026f1f4329ce4d2bec7ab149d40fa6a"
    sha256 cellar: :any, x86_64_linux:      "cb3d17cafca45d66f01c1ee16a9b0b08ec97b82a24928c7f2851e0ce9f8fdf8d"
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
