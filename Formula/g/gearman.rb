class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "https://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.22/gearmand-1.1.22.tar.gz"
  sha256 "c5d18f6a13625ebdd7e514596aed39e31203358eee688dfedcedd989a2f02d7a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0984eb4b3479e4384b4e490f9241bb4a1ca271039287dea1bb356a16eb977d1"
    sha256 cellar: :any,                 arm64_sequoia: "8c955584d99f3e859ea660c00bf2bcfe0cf2f402f193a3eb221345799200c835"
    sha256 cellar: :any,                 arm64_sonoma:  "103e4d6a50dbc070bca6776516b3843b80bdbdb655d2cd64a1bba916c62fbfd6"
    sha256 cellar: :any,                 arm64_ventura: "a6e2b34f1b2cf3900fb2127ca36592b87c717d7cc53ee7ac88a47b0c5bf0970e"
    sha256 cellar: :any,                 sonoma:        "a7397e17e36abfcabb7456690e9afb6b972ccfb24f764de51de6649a63711ec7"
    sha256 cellar: :any,                 ventura:       "6d8bf0e70335d64283ed5123e6b881b08674ac97a12905a2b10751292daa85c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7362e35e325a83661ab189ca487908cb25f37b7dcd267775663fa997e09f740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a97c37df4ed3036bfdf1fb1318fbeb99a34bcb3f6a3353ea55853c4aa008cee"
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
