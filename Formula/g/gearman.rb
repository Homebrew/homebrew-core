class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4467566d914682138283953f1311ddf23572a4afd959d82ac0b2a603549e0cee"
    sha256 cellar: :any,                 arm64_sonoma:  "4b67a0129dce2a868d5079867cbdb4d115d9eae56ec52a41c9b562a509415599"
    sha256 cellar: :any,                 arm64_ventura: "008c71b1e3df7004c782f0278295b7b3a7e664ffba761a30975e4913134ad2b2"
    sha256 cellar: :any,                 sonoma:        "6c5c2cace944c91f0306e7f4ec3ee247fa9af89b8b9b24c2ce66a6c9ce1260de"
    sha256 cellar: :any,                 ventura:       "6fc4431c7fab994717bb3a95f4b0f716398a4ebd83a5c677ea9776f7df211600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c855de1197c2a51653daf11305124821fe5fa2283f604dfbc332f6cee4e4236"
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
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    if OS.mac? && MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

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
