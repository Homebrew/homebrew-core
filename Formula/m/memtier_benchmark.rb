class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/redis/memtier_benchmark"
  url "https://github.com/redis/memtier_benchmark/archive/refs/tags/2.4.4.tar.gz"
  sha256 "d9bb75d4b7432ff0602e0e5d84078928a2305cba9e11c46a7d191cbbaccf963e"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e5ab9de8c823565c2734ddb6508bf6315349a269c6747eb0a70db59d7a0b40e4"
    sha256 cellar: :any, arm64_sequoia: "f3f62b509f5f8d800613a2ff6535283b73f8f38a15ff151c357021cdf031c9e6"
    sha256 cellar: :any, arm64_sonoma:  "a8d1593d04b33475d9dc82bdf2d6c2a0f8441ccb35afc53b4cfa42f30816947c"
    sha256 cellar: :any, sonoma:        "7ee4980b4ce4361dcf4c6b964760e70878e2438d817023f5089cea291e294048"
    sha256 cellar: :any, arm64_linux:   "9527655d83e43c64617c8e3a3201f90815868247d2c0f093626e009492573528"
    sha256 cellar: :any, x86_64_linux:  "08f38885aff448827bd5670052b9fc2d659e969e0289e06702831e17b307df24"
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
