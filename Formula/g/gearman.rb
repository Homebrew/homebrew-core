class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "060faa3a9871dcbbaeef57333b7fa75f078ff5494649708b9dbefa88ae73f163"
    sha256 cellar: :any,                 arm64_sonoma:  "df3265ff5e08cd1e45980fce280622cc1f193928bc01032af8ee26513b6fef76"
    sha256 cellar: :any,                 arm64_ventura: "5ca0cc364c7b043186134711deb86d75c91fda9bc3c684040ac927175e646858"
    sha256 cellar: :any,                 sonoma:        "eb219f8ad13112d89d5c93886c3f50296fbeba85b9fdc3a8f72c7a17fcf40826"
    sha256 cellar: :any,                 ventura:       "c8481a6f4d55d6b47ae8aac28bb7c44dbbc641fae253d0e074e31d8dabefba83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dff3c3b09510935a9099cf7a08f9d8cc83005d2b724b6910bf095ea2fe36697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e753a4c1a89536e1e907a2a4006d947052c7103271289371ca0301d7a9ba83"
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
