class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/releases/download/3.4.2/manticore-3.4.2-200410-6903305-release.tar.gz"
  version "3.4.2"
  sha256 "a5dcdb561db57fd59fab63531eb23f0585f48432ef8be2b94ec6d979d0f35894"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git"

  bottle do
    sha256 "040e35553be1cba6b646bca39b25be32a6ce5cd9e9abcc7be1979d9efcd7649d" => :catalina
    sha256 "15c3a9697847baf7879269c99f7590fb1ca07afc528cfeca8ef170a783bf1998" => :mojave
    sha256 "f7a83e56c1392ebea74ef19929c7d3f4f29cfb5f4bbe08a36a55395ca3277d40" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c" => :build
  depends_on "libpq" => :build
  depends_on "mysql" => :build
  depends_on "unixodbc" => :build
  depends_on "openssl@1.1"

  conflicts_with "sphinx", :because => "manticoresearch is a fork of sphinx"

  def install
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DDISTR_BUILD=macosbrew
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

  plist_options :manual => "searchd --config #{HOMEBREW_PREFIX}/etc/manticore/manticore.conf"

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
