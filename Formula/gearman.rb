class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.20/gearmand-1.1.20.tar.gz"
  sha256 "2f60fa207dcd730595ef96a9dc3ca899566707c8176106b3c63ecf47edc147a6"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95b2c5141c5811012eb63f2bde53ce34b8b10d44091d83ca26fdb9f90f952c7f"
    sha256 cellar: :any,                 arm64_monterey: "47ae5c4a1e46839d326f9d0a8645db99667faa9421d6b1f24ef8428d88114fc0"
    sha256 cellar: :any,                 arm64_big_sur:  "9f4604a39f29d820d364501feec99fe4224d365d308dc4b1a2e85499b14fd906"
    sha256 cellar: :any,                 ventura:        "fb41eeff69f94675705274a2a9791d576659898b6a34a49b8ea4385dbeed3785"
    sha256 cellar: :any,                 monterey:       "a07630494be1b88b82cc38c9f255ca29f6387b85dfe7cf239b29652b7a632309"
    sha256 cellar: :any,                 big_sur:        "1d99f2e4f0dff33a17832e43e1b3b7b4c749311bd838e3c8796548adf8e48be2"
    sha256 cellar: :any,                 catalina:       "cf60ac6edfc875eebdbaacb3831247a294e1e844441eb1417d4c648f4e0d91c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f8b04328b9fbfa337b299811b3dc21c12c47448692a881080e955633b2f5279"
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
