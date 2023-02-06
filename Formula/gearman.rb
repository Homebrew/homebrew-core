class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.20/gearmand-1.1.20.tar.gz"
  sha256 "2f60fa207dcd730595ef96a9dc3ca899566707c8176106b3c63ecf47edc147a6"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56f8a2607c3974a05f26a0228110d92644b8c55ba33748d9cacea344835f0647"
    sha256 cellar: :any,                 arm64_monterey: "ef1f9565f364f0ef2c609368f948889a663e613d0444fed501a955cc0cd8d4da"
    sha256 cellar: :any,                 arm64_big_sur:  "4e58758ab0e23da7d42dd2df7bc37f0000344c8fb6e48f74eed8a82da97b7db2"
    sha256 cellar: :any,                 ventura:        "4fb671b56f94bfd2890e7254562b17d085608ae08474e2cee905a4b56f274138"
    sha256 cellar: :any,                 monterey:       "b4dd7a044f2df431fa9fdf591bd677713e96085e8c1019832cadcfa79b957d33"
    sha256 cellar: :any,                 big_sur:        "de3c60bc5ef48594bbac864ba5ed7530256ffea60008370a683190fa78223330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac573d6b5ca6838e133cc2dc00b13909448e69a2d511773e9a0cd7e8f2f3bb30"
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
    if MacOS.version == :high_sierra
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
