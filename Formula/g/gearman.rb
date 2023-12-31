class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b004f8a7a32009a63fac5a3f9a70d7a90249509cf439f977bedbe853cd6578c7"
    sha256 cellar: :any,                 arm64_ventura:  "c2aba68a9785c5c0c8bee4dd96521aa502dc16a7217c6dfde7a8ce1fc51c3cda"
    sha256 cellar: :any,                 arm64_monterey: "7219be98ad0e371285a285151221769fb1dc3eab1f7f5478aa856bfbca6e145f"
    sha256 cellar: :any,                 sonoma:         "8ab0bb48ee52dfbc4a51aba1924d99f00eebe1e71660dcc5e3b3f2b0eb72ee28"
    sha256 cellar: :any,                 ventura:        "779969df911562d4547e4fb59187b34286383b0709d6dfa0557012a7a53d4526"
    sha256 cellar: :any,                 monterey:       "f648ee691c4386c668a72676306293182d1b39c68d70fce5b5b851e53ba3f195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d983fee09de276991f93eaf17ce8aac836b77fed67868f2249ab1c33ff668ba"
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
