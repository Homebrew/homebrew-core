class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.4.3.tar.gz"
  sha256 "88de452b2a6e1ecef0064c98be046ea032771d9f1c8874d2bec9caa946c0acfe"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f95b15e045eee10cb822a49a3d84a50ace49f48850189cfebb4c84d70eb5155"
    sha256 cellar: :any, arm64_sequoia: "ef3c2cca015432d787deeb5578fdba7c2a793929d11c604854dda2e3d2427ff6"
    sha256 cellar: :any, arm64_sonoma:  "41fdb24f6500bb56ef8c1fab69b14359991fee89e75892d8e058786ea7fab5fa"
    sha256 cellar: :any, sonoma:        "d24e58e09887e34b01348f070f3bcb521e4baa5b78dde959f80ee0acda50c1c5"
    sha256 cellar: :any, arm64_linux:   "24bc58c4478961582edf5469d11998464734f7914593d54befade325d2cd9649"
    sha256 cellar: :any, x86_64_linux:  "af11725691d9405df1229bda8287b81fa51732f067b02911fe80476541ddf580"
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
