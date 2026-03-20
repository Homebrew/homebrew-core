class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.3.0.tar.gz"
  sha256 "4c3238e28e63b524e6adf31e3c306af911597c5a73da4957b1dd2498d6ae7c74"
  license all_of: [
    "GPL-2.0-only",
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03525566fd7229ce01fd67ff0f8e5f44686563f9d065e05c212010decc6f2fb9"
    sha256 cellar: :any,                 arm64_sequoia: "270f791eb49387c8c24917606965e4023eea61c0fc9a7442ea22453f6cbcbdc2"
    sha256 cellar: :any,                 arm64_sonoma:  "ad69ba4c724efdcdc3e9d2af571550ea7d387a61077e846e72007c68550110d1"
    sha256 cellar: :any,                 sonoma:        "fd75571a0a7dd119f69ca7db02c881511337fe810ff8243a94910158c47a9390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aba9d3e7070b0c3199a54c31fad19a81ea81b882e3af20c97e82dc98a682537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f24d6e70b892c9be1fbdf314fb1489228e0be3a2e9091ff713892f599ff988cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

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
