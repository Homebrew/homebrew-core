class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://repo.manticoresearch.com/repository/manticoresearch_source/release/manticore-3.6.0-210504-96d61d8-release-source.tar.gz"
  version "3.6.0"
  sha256 "320a19c837caf827a75e19e11755a9586487435aeb8b8aa80e8bef552fd5e1f5"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "e285345ff7b6a8a99c0cbac69232301a6ad97cd09abae93bfffce5d3885f6ac2"
    sha256 big_sur:       "11dfe819517e1b8c379d761ed9391192bb585564588a0ee23f85880a4b7e2f8c"
    sha256 catalina:      "77c342a7a0d4a7c786b2c777b92522ab8b9eae7806074b0f81112cd7890c4d91"
    sha256 mojave:        "f20768ffb1961f40fe39b3bebd20491f31cd2d91f9c43c4b5897458a50354a06"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c" => :build
  depends_on "libpq" => :build
  depends_on "mysql" => :build
  depends_on "openssl@1.1"

  conflicts_with "sphinx", because: "manticoresearch is a fork of sphinx"

  def install
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DDISTR_BUILD=macosbrew
      -DBoost_NO_BOOST_CMAKE=ON
      -DWITH_ODBC=OFF
    ]

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
