class Clickhouse < Formula
  desc "Free analytics DBMS for big data with SQL interface"
  homepage "https://clickhouse.tech"
  url "https://github.com/ClickHouse/ClickHouse/releases/download/v21.6.3.14-stable/ClickHouse_sources_with_submodules.tar.gz"
  version "21.6"
  sha256 "696bbcdef4796bfdf1becdb78abb5e97c0220acc9863f5a821193dd297ce428b"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/ClickHouse.git"
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build

  def install
    mkdir_p bin
    mkdir_p "#{HOMEBREW_PREFIX}/etc/clickhouse-server"
    mkdir_p "#{var}/log/clickhouse-server"
    mkdir_p "#{var}/lib/clickhouse-server"
    mkdir_p "#{var}/run/clickhouse-server"

    inreplace "programs/server/config.xml" do |s|
      s.gsub! "<!-- <max_open_files>262144</max_open_files> -->", "<max_open_files>262144</max_open_files>"
    end
    inreplace "cmake/warnings.cmake" do |s|
      s.gsub!(/add_warning\(frame-larger-than=(\d*)\)/, "add_warning(frame-larger-than=131072)")
    end

    args = std_cmake_args
    args.delete("-DCMAKE_BUILD_TYPE=Release")
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"

    system "cmake", ".", *args
    system "ninja", "clickhouse-bundle"

    system "#{buildpath}/programs/clickhouse", "install",
                                               "--binary-path=#{bin}",
                                               "--config-path=#{HOMEBREW_PREFIX}/etc/clickhouse-server",
                                               "--log-path=#{var}/log/clickhouse-server",
                                               "--data-path=#{var}/lib/clickhouse-server",
                                               "--pid-path=#{var}/run/clickhouse-server"
  end

  plist_options manual: "clickhouse-server --config-file #{HOMEBREW_PREFIX}/etc/clickhouse-server/config.xml"

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
            <string>#{opt_bin}/clickhouse-server</string>
            <string>--config-file</string>
            <string>#{etc}/clickhouse-server/config.xml</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/clickhouse-client", "--version"
    query = "SELECT sum(number) FROM (SELECT * FROM system.numbers LIMIT 10000000)"
    assert_equal "49999995000000", shell_output("#{bin}/clickhouse-local -S 'number UInt64' -q '#{query}'").chomp
  end
end
