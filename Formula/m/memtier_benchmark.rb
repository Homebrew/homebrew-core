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
    sha256 cellar: :any,                 arm64_tahoe:   "6f7250cd7ec6fad9a1812331d92c5dddec2ab54861c0278caa8ef910e03a87e2"
    sha256 cellar: :any,                 arm64_sequoia: "9457a25002adc784f4b64e7f7450b78ebefab7cf1ee69845b1bb66add9ab1aa0"
    sha256 cellar: :any,                 arm64_sonoma:  "ecf0c6bae7f090a41bc42bf22342c997a175b7bf89480ed2a56e11980c387932"
    sha256 cellar: :any,                 arm64_ventura: "9c88ffef0cb40817b88783d0282e0136295ed37e5e402f417904399c5f197c5c"
    sha256 cellar: :any,                 sonoma:        "92788f00ae115e84e974e13eb28eb7744195b431a64f383d47c04592475ee9af"
    sha256 cellar: :any,                 ventura:       "0aff9e251e7b54fbd43686af42b1245dac431386c8c5e8af5fc0e0cb633ce718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c0167e937cc0c9c062cdd6ae76ee1bd37fcf8fa2266d74c05ce533e033f6128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd1bf48057bccd856e93cb57effc0c22a2832dd45770fba82da1049a97b8edd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre"

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
