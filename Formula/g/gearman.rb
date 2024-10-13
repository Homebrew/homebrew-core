class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.21/gearmand-1.1.21.tar.gz"
  sha256 "2688b83e48f26fdcd4fbaef2413ff1a76c9ecb067d1621d0e0986196efecd308"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5cdfdb84c2102f65926d2265929435a919eca018f7535e7cc68c022923065b18"
    sha256 cellar: :any,                 arm64_sonoma:   "9d1da4a4f4163500fa5526812bc3a0568378e01a89001545bf45cee7c61d5ed7"
    sha256 cellar: :any,                 arm64_ventura:  "4b43f495ded047c9a8bbf9cd1007151049cebf7cefcde392d00b9e3bb16b6bdb"
    sha256 cellar: :any,                 arm64_monterey: "93ccbc7bf2fe168924a57d16851206fbf781f3ff78460c66f1e97e5551287bfd"
    sha256 cellar: :any,                 sonoma:         "af960e8b7736a776909060bb4544f46058ab065a4bef2472b02bd4119142f2c1"
    sha256 cellar: :any,                 ventura:        "30f5a814200b4eef0fa30ed3a26d526c18cf8fd03e9466e37699c1f16a09ad07"
    sha256 cellar: :any,                 monterey:       "157e08eabcf0400b1f4c79a678b77433fc3d6c10390b372c641478ed4e5352c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285adf59fe86f27e59a6292255c4d62b281db259ec4f6f49a88469a8e0491e3a"
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
