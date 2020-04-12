class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/releases/download/3.4.2/manticore-3.4.2-200410-6903305-release.tar.gz"
  version "3.4.2"
  sha256 "a5dcdb561db57fd59fab63531eb23f0585f48432ef8be2b94ec6d979d0f35894"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git"

  bottle do
    sha256 "81caa9e99d521b09413ec8eacb87002bb8fe2aa9c23501fb9b0147febb8a4a70" => :catalina
    sha256 "dbb618ba4468d7054609964e0323f7796996f0d90614fafd969b4acec5df8d72" => :mojave
    sha256 "59f3a80dc395813ad3fb74d2a3bcd128ed17353ec35fe28afa3c3ac7e43b8f55" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c" => :build
  depends_on "libpq" => :build
  depends_on "mysql" => :build
  depends_on "unixodbc" => :build
  depends_on "openssl@1.1"

  conflicts_with "sphinx",
   :because => "manticore, sphinx install the same binaries."

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
