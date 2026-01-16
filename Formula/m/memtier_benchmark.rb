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
    sha256 cellar: :any,                 arm64_tahoe:   "3e15c6fea91dc997dc546c8a29ae42a0be0934d2ad90c05a5702ac35144df9d6"
    sha256 cellar: :any,                 arm64_sequoia: "c455afad00fa3c262967a688113cae7fb99a3a57dd8598f1d4e56343590b5416"
    sha256 cellar: :any,                 arm64_sonoma:  "a47cce15057b9c87c01b2d4937822a91e3855e94594b1c25e36f1ca5837b2b6b"
    sha256 cellar: :any,                 sonoma:        "b66a8ea448dda20fa590224b20d55ba357601c38ead37726a86fc1d53a7045b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8917d60ffd266846cfb82fbc1b9ded44d8c12b9f8266237aab88109f39e0df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c877599a2e60a755c2751518988ee1906d30a27bfa4d21f9ac91075311c49d23"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
