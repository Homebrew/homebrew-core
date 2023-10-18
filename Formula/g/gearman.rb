class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.20/gearmand-1.1.20.tar.gz"
  sha256 "2f60fa207dcd730595ef96a9dc3ca899566707c8176106b3c63ecf47edc147a6"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "997c804fb16469b0eb29b09b9d6923ad2afa604b5f9ae504f9c3f1354f3aa2c7"
    sha256 cellar: :any,                 arm64_ventura:  "a3ac55be2e9b5f0ec1cec2ec73c1676d599c314238dfce05860f729f736d1541"
    sha256 cellar: :any,                 arm64_monterey: "70f0ea8d07134f55a0bb70babace48fa7e7b644fd8bbf3fa498d6395c49e3952"
    sha256 cellar: :any,                 arm64_big_sur:  "da50dc9309cb558b343e67b59756a3a7422bdbb49b228374f41f9755651fb654"
    sha256 cellar: :any,                 sonoma:         "7bcb978e3cec74ae0ccb30d8919b033856153a726bd1e35c1a669fe2eec0324b"
    sha256 cellar: :any,                 ventura:        "71e97c71fe5b644450cc63ec0b6ad63558e836f21eb242877c55ea6a16480b88"
    sha256 cellar: :any,                 monterey:       "0c19c9c73a38c3acb985e23af7a0f24a03873ac3ff4d648d486609e61548deb0"
    sha256 cellar: :any,                 big_sur:        "888c6fa5fe26169298cbf25963c903729829e90c757e1de842ecf335e026f31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de7c693999d67429d0161af656492143c90cd7ece6cf419d534614f4ba66229b"
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
