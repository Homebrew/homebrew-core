class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/redis/memtier_benchmark"
  url "https://github.com/redis/memtier_benchmark/archive/refs/tags/2.6.0.tar.gz"
  sha256 "80cd749a0661a51d60cc61b7b2541c5022dab952629e456dfa6b91a48475f1a4"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "793d956c312e8d840cc9d5582b7de4309fda0cfa512325d6c6106510eaccc6fd"
    sha256 cellar: :any, arm64_tahoe:       "120bb635255e032ecd20a369f864f888798f385087e375eca4ae3777412ffb86"
    sha256 cellar: :any, arm64_sequoia:     "0ab4d4464e265dbd327d9641870053e5896bf76bbfc70437bd7932a6d6e608ba"
    sha256 cellar: :any, arm64_linux:       "df99eb23350d8a2a3299babe1249d892d0ddd1279596dc86167bad81e86f1efe"
    sha256 cellar: :any, x86_64_linux:      "7f5e2da9402e5ab85b14fde7084d0669cf357b68f887cbdd5cab49351b1b3ee2"
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

  allow_network_access! :test

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memtier_benchmark --version")
    assert_match "ALL STATS", shell_output("#{bin}/memtier_benchmark -c 1 -t 1", 1)
  end
end
