class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/4.2.0.tar.gz"
  sha256 "6b4af70fcc56b40aa83e606240b237e47e54c0bfbfdd32c47788d59469ef7146"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "f55f960076fbee621f9292de41f671db7aab5587eec035e9ee9060268b3f306c"
    sha256 arm64_big_sur:  "37f16dfb2b31f7dacdc1818a4417f765637c1de051ade808b1123bfba2d125d3"
    sha256 monterey:       "509bc6f6379aad68ad2df404becf0183653b87400d38e3fb897afb6088209939"
    sha256 big_sur:        "717f6d93410c969f7d1c717af610cfc8815548b6835208b5c690639c48a384f0"
    sha256 catalina:       "0595b59292ca6b2e1f947f053720ce4c478111736df58d76048ad43b7bf4cfac"
    sha256 x86_64_linux:   "704acba2d67a0e365ac8f458969be7ba54fed2390797aa6b93fcff1a74bdad96"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql"
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "sphinx", because: "manticoresearch is a fork of sphinx"

  fails_with gcc: "5"

  def install
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DBoost_NO_BOOST_CMAKE=ON
      -DWITH_ICU=OFF
      -DWITH_ODBC=OFF
    ]

    if OS.mac?
      args << "-DDISTR_BUILD=macosbrew"
    else
      args += %W[
        -DCMAKE_INSTALL_BINDIR=#{bin}
        -DCMAKE_INSTALL_DATAROOTDIR=#{share}
        -DCMAKE_INSTALL_INCLUDEDIR=#{include}
        -DCMAKE_INSTALL_LIBDIR=#{lib}
        -DCMAKE_INSTALL_MANDIR=#{man}
        -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      ]
    end

    # Disable support for Manticore Columnar Library on ARM (since the library itself doesn't support it as well)
    args << "-DWITH_COLUMNAR=OFF" if Hardware::CPU.arm?

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "make", "install"
    end
  end

  def post_install
    (var/"run/manticore").mkpath
    (var/"log/manticore").mkpath
    (var/"manticore/data").mkpath
  end

  service do
    run [opt_bin/"searchd", "--config", etc/"manticore/manticore.conf", "--nodetach"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"manticore.conf").write <<~EOS
      searchd {
        pid_file = searchd.pid
        binlog_path=#
      }
    EOS
    pid = fork do
      exec bin/"searchd"
    end
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
