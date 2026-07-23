class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/redis/memtier_benchmark"
  url "https://github.com/redis/memtier_benchmark/archive/refs/tags/2.5.1.tar.gz"
  sha256 "9b34e17a0d1d7e70b152eb442c6362161b5b764ce2ea98e97b7c74815bdd90b7"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "917615b800023f2dbe77937c14a5b9d84b33178fff3ca4303b5b1443cb7ab318"
    sha256 cellar: :any, arm64_sequoia: "9f6bb51bb2998e061f3d6dd8ca73c3db84004d570deb09044e38e6449d46a547"
    sha256 cellar: :any, arm64_sonoma:  "1187ffad0ce82fe1b13342b5af3ec972bb1e507ac58d51add8a8772156b6d82d"
    sha256 cellar: :any, sonoma:        "498d4e24e59dd8128e81e2542f674033c94d3aa52d0fa419f563174e93ccd19f"
    sha256 cellar: :any, arm64_linux:   "4b14b9e404e364bca55cfc7ace64c6d37fd3a62f398b40d8246d45653f11cf6d"
    sha256 cellar: :any, x86_64_linux:  "c2f117a69674fb2ac5fc5824279f0c1061fc0f48d003d8c3b3017c8776b75da2"
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
