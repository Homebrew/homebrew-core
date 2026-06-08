class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.4.1.tar.gz"
  sha256 "ef6f64a96385aa215702a0544db2e77711c93440fad73787d7bb6396fc97c0e5"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "910510dea3e8893390580f540dd172e8342cfcc1cb87b60cad1b73b6d924ea6f"
    sha256 cellar: :any, arm64_sequoia: "a8bb7be204410fcfac69653f8b4015a97bfa6c3f1949b4a8c77e48decfa987cb"
    sha256 cellar: :any, arm64_sonoma:  "721994305fdceeabdb563ea3fe3611b57055d9516af20e0b67d6554ac19d0000"
    sha256 cellar: :any, sonoma:        "c860fe8747cbbc63378235067cd4cc2932d56877e32900d6fd4b544982130c1f"
    sha256 cellar: :any, arm64_linux:   "6cb5e33d429fca2ac8d9ad47bf09b7a5597f82a91759cdd61b3fc75f4918ee58"
    sha256 cellar: :any, x86_64_linux:  "e63ca29fed05e7ff539630529407a9f39cd847607a2eab2b06c57e737c843f59"
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
