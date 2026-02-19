class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.2.1.tar.gz"
  sha256 "e417382826ea1b93f93441bfa52d7556fb41a85b29e20d5f87c4b1a972ee3a6b"
  license all_of: [
    "GPL-2.0-only",
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4d36a3cb9900ea9b397699039b18980fc45d608aa566f0c9dac77a5d5df1eed9"
    sha256 cellar: :any,                 arm64_sequoia: "15d9ee5844ebbce91eb04ddff1f47d289e56a47776d6e672159a930e5cbef8ca"
    sha256 cellar: :any,                 arm64_sonoma:  "a626d8423044c81a10b7bb1e41a26f0773199f08208d70016e47210f001b30ac"
    sha256 cellar: :any,                 sonoma:        "cd45aa2f31638d23036bcb45004c0e416aaf413280ac3334286a8c4ea8ed8f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00785ad2b1807dc203e76dd605e188fc5e7412adf371372ffd44fdf7d357a83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a6effe93ef02c8990f0e6ab3a22819bf15e7f6fde2ef804b671ed121d19eb8a"
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
