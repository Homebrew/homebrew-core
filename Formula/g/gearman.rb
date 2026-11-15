class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/2.2.0/gearmand-2.2.0.tar.gz"
  sha256 "fec69ec0e893147a9eb8bfa203e173cc5598adc372e307fea12d587d13071d75"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "da498d8e5e0e1fa3fba4f9b80abbd7a16813a9927d9af78cb477d8f1a2bb0378"
    sha256 cellar: :any, arm64_tahoe:       "032a27a02aa3dc453fbc8e53d63bb0e96fba75d3fab28c975b92f28ef09b99e4"
    sha256 cellar: :any, arm64_sequoia:     "07bf9cfe00b8256dbef7c2675f0bf2ca775867020337163df1b0cf5abc355e54"
    sha256 cellar: :any, arm64_linux:       "57aca997c644dbe6efabd1419d580d291e799bfd38919ea6bac498f8dbf5d486"
    sha256 cellar: :any, x86_64_linux:      "6dbcf92bf03e5c9f8a58a644574d226a48311be20bccb3218ca80b5aa0ed27eb"
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

  deny_network_access!

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
