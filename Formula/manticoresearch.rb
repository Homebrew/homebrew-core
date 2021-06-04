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
    sha256 arm64_big_sur: "30452ef44c28fa988ed5b8a42b1ef319cad80449e1ee94761b97dd601529faf6"
    sha256 big_sur:       "97f2d35c667bbf98e830104523659fa070163dca549a1a4437b2cf58d3d31c1d"
    sha256 catalina:      "1f4bab27f0f29378e6b4edf3b989361d5b0169c4cc06490dafc9afec38b87a7c"
    sha256 mojave:        "5a6d4ec64e5f6cd8a2a8041b7823a120ee1333a779a3cae11e13972edc89129f"
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

  plist_options manual: "searchd --config #{HOMEBREW_PREFIX}/etc/manticore/manticore.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <false/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/searchd</string>
              <string>--config</string>
              <string>#{etc}/manticore/manticore.conf</string>
              <string>--nodetach</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
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
