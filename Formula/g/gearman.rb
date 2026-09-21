class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/2.1.0/gearmand-2.1.0.tar.gz"
  sha256 "4d24340ab39be851b40d895687c17d6d16e730ece1fa9d9294d6b2b0a8cb1261"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4dec982c4c97c4d0cdb91d93c3db5b140e39689eabd6d610057ccf7adb26c7be"
    sha256 cellar: :any, arm64_tahoe:       "37777223a74886d6990baccaa7be3328158b642c456113f17885b76b91625a3e"
    sha256 cellar: :any, arm64_sequoia:     "1f86fead5d81f99d0bb1df31602cd4d08b5854f01eee1b211ad55c249e38e92c"
    sha256 cellar: :any, arm64_sonoma:      "fe4e152aaeede12c1c2edf442510a8dae9ce07e79f7dbb5e4a5a0f5805269cb9"
    sha256 cellar: :any, arm64_linux:       "689317e40bd208580eee3efeb6a1c50be9ecfe3d814e494ec365a2816b16e1b8"
    sha256 cellar: :any, x86_64_linux:      "f0bfda5641a2ec601be92fecd4e6785141309e0d0bbe93866be5ddf3b3e25761"
  end

  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libmemcached"

  uses_from_macos "gperf" => :build
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-cyassl
      --disable-hiredis
      --disable-libdrizzle
      --disable-libpq
      --disable-libtokyocabinet
      --disable-ssl
      --enable-libmemcached
      --with-boost=#{formula_opt_prefix("boost")}
      --with-memcached=#{formula_opt_bin("memcached")}/memcached
      --with-sqlite3
      --without-mysql
      --without-postgresql
    ]

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"gearmand"
  end

  test do
    assert_match(/gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1))
  end
end
