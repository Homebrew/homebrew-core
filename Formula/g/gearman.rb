class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f37a97052a0c768f6474c07ee6dc636720099622645e1c3c7ba0f4c9c8f6b4bc"
    sha256 cellar: :any,                 arm64_ventura:  "479948561c6e4e081bb53d3bd3128b9ab52b7455d4a4848a421328b2dc2baa25"
    sha256 cellar: :any,                 arm64_monterey: "9c5707a987732d2186688e7a394cd365d4b95b2fcb65243ee978a9dca6030961"
    sha256 cellar: :any,                 sonoma:         "912859d0ae86ffacf41772d91f5d1ed426ed0cf8c19e7a6c961696502b0ff6d5"
    sha256 cellar: :any,                 ventura:        "5bdc353fd35e643166441a9a4f1421b048f8b8a47939fcb1bfd61600870b7619"
    sha256 cellar: :any,                 monterey:       "73bde1653a0fd68c2e6e978a3a9ba70c2066c152dcb75364d984a53e61c9fbe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a58ca217f1d747007d9796533836368b7cb598541b412a33336f86e072af0472"
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
