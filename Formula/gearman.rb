class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.19.1/gearmand-1.1.19.1.tar.gz"
  sha256 "8ea6e0d16a0c924e6a65caea8a7cd49d3840b9256d440d991de4266447166bfb"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f0a2a49ce3a773f7c1a6843209a6cd08685cd4006c9a9a42027ba49aaa3e8df"
    sha256 cellar: :any,                 arm64_big_sur:  "e4ead0b0570c3c6d45bf2d819ab72ac18d23818fa738bfde4e85567afccab5aa"
    sha256 cellar: :any,                 monterey:       "2abbf0333fc05b02a35ae4b2a0ab87a477c39594028a7f6a778dbebded6c6b03"
    sha256 cellar: :any,                 big_sur:        "acfaeab90270a909593744b93f070eac9c0a304a72e5aa9e8239a1611fd7232c"
    sha256 cellar: :any,                 catalina:       "70b0a28d14bf035972ad57d124d1bb968c47e016f2788567ee5bb6e44f35e74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495913ba7fe75023898cde122e9b7a3d8a89094a4f3ae8cf941bc66a6e7a4877"
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
      next unless /std::unique_ptr/.match?(File.read(test_file))

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
