class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/4.2.0.tar.gz"
  sha256 "6b4af70fcc56b40aa83e606240b237e47e54c0bfbfdd32c47788d59469ef7146"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "e285345ff7b6a8a99c0cbac69232301a6ad97cd09abae93bfffce5d3885f6ac2"
    sha256 big_sur:       "11dfe819517e1b8c379d761ed9391192bb585564588a0ee23f85880a4b7e2f8c"
    sha256 catalina:      "77c342a7a0d4a7c786b2c777b92522ab8b9eae7806074b0f81112cd7890c4d91"
    sha256 mojave:        "f20768ffb1961f40fe39b3bebd20491f31cd2d91f9c43c4b5897458a50354a06"
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
