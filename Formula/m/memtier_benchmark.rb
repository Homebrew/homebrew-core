class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.3.1.tar.gz"
  sha256 "e278695435920c30203ceb0b561f2cbc08f6977935936a5f28c9864c0b76ddb0"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce08831abdd10ddc2cb1561006fbbbca6354be54a0677b7dbb094e4548bdbd1e"
    sha256 cellar: :any,                 arm64_sequoia: "dbc93842e4c09136bcfaa56de091071ceab0392f806fba60fe009f4f9acdfa2b"
    sha256 cellar: :any,                 arm64_sonoma:  "f3d3f5685f902e5e48787cb9175723648fdfd3fc39cb30b261137af58cc1f5c3"
    sha256 cellar: :any,                 sonoma:        "fea16c0d730681376799a7de3057f2fe6dcadd519dac8eb5bc00b1f243d675c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3748336d1da7af83430aa694e7cbff85b3054d1a1b297c9d181b63fcd556ecaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7c70e85800beb9da78f6b89851d7d251c25f5cfd980417a178b6b7fbc9d33d9"
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
