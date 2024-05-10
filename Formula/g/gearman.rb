class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74f5aa57dbcf69a26944221ef18fba6b822087ea7b39277763014c48e38bd400"
    sha256 cellar: :any,                 arm64_ventura:  "22708e244f0929d56c2d2a51c6c3aed5d696374836fac0d35cbd7a1e9292b8ad"
    sha256 cellar: :any,                 arm64_monterey: "1bd6ee6cc9c64a344a0b5c0a19d6acc72abbe6ca4522ba82f6e95e84540f6854"
    sha256 cellar: :any,                 sonoma:         "e13aa47f17d1aa91e3879baaf4a9ed56714b2ebf2fc0f9be3efe17e02b068156"
    sha256 cellar: :any,                 ventura:        "69e8a9f74ab27c7625227fbb074d263dab038d5bb6ab1bcffeb816d142d18b62"
    sha256 cellar: :any,                 monterey:       "eb6cb5c35772f870d9b09c899a9359625edb47d0fa1283997ac9832987aa4267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a082418fa3b4fc4be651b4e8237b46f1a2b5c681e32553a144241323dce57e"
  end

  depends_on "pkg-config" => :build
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
