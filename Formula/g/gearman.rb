class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/2.0.0/gearmand-2.0.0.tar.gz"
  sha256 "690cb9c7a58c03d6be18031dc4a1a93778f6fa713590b4ce527ceb8b43ea0688"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e213e001e9c272e0a92fb91ba0b7e67bf7b2ac7eb4653c429a802c0e5ce3b9d3"
    sha256 cellar: :any, arm64_sequoia: "ee474ffaba4e54d9f51ac80bfcd996d9c89aa1d4ecaf4f189ca883dcd7937ede"
    sha256 cellar: :any, arm64_sonoma:  "a7773053c52c0a1bbe15b9c0156ff43777c3aeca4407bdf123b815e41d3b1317"
    sha256 cellar: :any, sonoma:        "423b51292404952fd8582bf4ee97c3ef1cf0fffc49bf7942ce9be4210b8e9b77"
    sha256 cellar: :any, arm64_linux:   "09181ac2b149b5151d354d945a97e7bbbeab3cc0909ae7a41c350b25c4c4f5a1"
    sha256 cellar: :any, x86_64_linux:  "6e6ed98d4401abfc68bc315e20b8eba17d979568f3e33a820fc676dc94b090da"
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
