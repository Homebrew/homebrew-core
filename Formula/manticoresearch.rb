class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://repo.manticoresearch.com/repository/manticoresearch_source/release/manticore-3.5.4-201211-13f8d08-release-source.tar.gz"
  version "3.5.4"
  sha256 "efe4b92650d31c89fe892750402e6343c5ee580e723ed6ac1235ca62b1e04b7d"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git"

  bottle do
    sha256 "565ac86782740cac8722fe21fc5ccbfed1396b95975187c8d4ef16601ad75a67" => :big_sur
    sha256 "6e8eab5ea85129311caca57dd605bae1bad03e7e9a021fbad9c6a2ebc5a204a5" => :catalina
    sha256 "9413bdb874c9e02936326f22b2f3343d9b4b1312db95c324b12045741f71f729" => :mojave
    sha256 "173f37791179e84ddf9d4304eee37a3a0ea6485847aa4d8ec7359623e884a1d2" => :high_sierra
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
