class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.2.0.tar.gz"
  sha256 "73bcdaca9a5e9c87c6f060637125885f8a01f178061fd67cd05f9da762d3490d"
  license all_of: [
    "GPL-2.0-only",
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fe41e5410fbd6119297a0cd33096ab7e7b557f8fd00ef8c415f579659170abd9"
    sha256 cellar: :any,                 arm64_sequoia: "2a7a858f3a3adef5a4b970642b090536e1debb3766cd254acd8b627e4d18747b"
    sha256 cellar: :any,                 arm64_sonoma:  "84eafcf539ad203a2eb7044bff2632301490e02951d8b019a41ae4186cacc0ef"
    sha256 cellar: :any,                 sonoma:        "6544f4bc25c790be6f0f93249580a05aca7d3f92d7f457a5430dfa127fa59b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "291b2c1df8539b7e33f65c459a159113808c173bc767393531363d060a149821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff298123c9b8d1d0fd2620edb33f388262d0502e88c0565958f754af714336d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # Backport removal of pcre dependency
  patch do
    url "https://github.com/RedisLabs/memtier_benchmark/commit/f3545b0f59ae21ad8b702aec9d15aacbccdbc41b.patch?full_index=1"
    sha256 "f78c13a299e7f4dbcd5926b0e111f06143e187d915d7811e4290f12125deab65"
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
