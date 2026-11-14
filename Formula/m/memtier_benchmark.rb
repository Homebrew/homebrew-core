class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/redis/memtier_benchmark"
  url "https://github.com/redis/memtier_benchmark/archive/refs/tags/2.6.1.tar.gz"
  sha256 "355ba99f511a45dc12edbffa963ed186b6a20554ace98dfcd72814565cf6eea7"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a51da7c122049b5c29d8a4425b45f740923c488757f470a2ce4310901218bf5"
    sha256 cellar: :any, arm64_tahoe:       "ae40da1fdff8aa72c39fa0758f74ac7d1a0135558f5e6d0082b73b69d394e29c"
    sha256 cellar: :any, arm64_sequoia:     "a590b1b16b663598a3e20934c6c84d812d7ed7a1531b9317dcb9be32d5f419df"
    sha256 cellar: :any, arm64_linux:       "6c0bc5141039bccb5399f8d858f91492fee28730bad5c0c4ad79ba08327448ce"
    sha256 cellar: :any, x86_64_linux:      "daa668a5eb67b043e8089db5cf58ad0d12907a96db6326d38b7af5987a78f17a"
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
