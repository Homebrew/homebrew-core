class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.22/gearmand-1.1.22.tar.gz"
  sha256 "c5d18f6a13625ebdd7e514596aed39e31203358eee688dfedcedd989a2f02d7a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d3c72680496377b84301a11829ce50486c4303b36e6fced1fded664a3e9e884"
    sha256 cellar: :any,                 arm64_sequoia: "9e6adef3fb88b33c1dafc83b2836780d15ec5dbca6e85426252910d74fb1328d"
    sha256 cellar: :any,                 arm64_sonoma:  "20e8012a0a1163aec0122be7ede14c1b67d8a9f2029c48fe4b0fd31bf6a7033f"
    sha256 cellar: :any,                 sonoma:        "34281099e7a338e50184e5297726d0fde308c108f8324cd4c8a807c2079b8525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c334d173303374e69d753ac458fbb7499c3bf5b7730bf9a98c9b77f061569531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3248cb1b494fc13da4014574ae3be3a88f592862de39ef275ed6a7824a996baf"
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
    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless File.read(test_file).include?("std::unique_ptr")

      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

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
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-memcached=#{Formula["memcached"].opt_bin}/memcached
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
