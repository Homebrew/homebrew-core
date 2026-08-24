class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/2.0.0/gearmand-2.0.0.tar.gz"
  sha256 "690cb9c7a58c03d6be18031dc4a1a93778f6fa713590b4ce527ceb8b43ea0688"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80e57d251960e8922de58fa5d9326743b379e7a0f55868598721d1571cc6e924"
    sha256 cellar: :any, arm64_sequoia: "d9836d744dd0d211fdb475e80ec1f332c3344c5d255dfaaef2106aa54d90e93c"
    sha256 cellar: :any, arm64_sonoma:  "33b8280d25a752a8be5acc0cf3eb243644b1f659e6493558db296d0830ddc89f"
    sha256 cellar: :any, sonoma:        "6463291352d58eda0e8115138afa6603c6d800ee5659f4c10318a0b4be852eea"
    sha256 cellar: :any, arm64_linux:   "fa91bb0b62358dd526722015e63ee80861af1205ec26f3850c644de911dd5678"
    sha256 cellar: :any, x86_64_linux:  "c76971cf595ff460a3d4dcdc70bdc9a60e91dbcc383afa0c94e920b6c625a67a"
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

    ENV.append_to_cflags "-DHAVE_HTONLL"
    ENV.append "CXXFLAGS", "-std=c++14"

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
