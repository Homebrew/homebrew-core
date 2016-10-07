require "language/go"

class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"

  stable do
    url "https://github.com/influxdata/influxdb.git",
        :tag => "v1.0.2",
        :revision => "ff307047057b7797418998a4ed709b0c0f346324"

    go_resource "github.com/dgrijalva/jwt-go" do
      url "https://github.com/dgrijalva/jwt-go.git",
          :revision => "9b486c879bab3fde556ce8c27d9a2bb05d5b2c60"
    end

    go_resource "github.com/gogo/protobuf" do
      url "https://github.com/gogo/protobuf.git",
          :revision => "6abcf94fd4c97dcb423fdafd42fe9f96ca7e421b"
    end

    go_resource "github.com/influxdata/usage-client" do
      url "https://github.com/influxdata/usage-client.git",
          :revision => "475977e68d79883d9c8d67131c84e4241523f452"
    end

    go_resource "github.com/jwilder/encoding" do
      url "https://github.com/jwilder/encoding.git",
          :revision => "ac74639f65b2180a2e5eb5ff197f0c122441aed0"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8d46d2c8328b32ce663b2e3447ed1a2eddf97f9a4be785da2cc648c869771d2f" => :sierra
    sha256 "8edec35bcf5921c860e2140f17f8d286063450c6271436232a5f67b57c03a859" => :el_capitan
    sha256 "12d7d4b39a8cf7723f7332ef92d2be009e69859fef3fea47e437341570239fdd" => :yosemite
  end

  head do
    url "https://github.com/influxdata/influxdb.git"

    go_resource "github.com/dgrijalva/jwt-go" do
      url "https://github.com/dgrijalva/jwt-go.git",
          :revision => "63734eae1ef55eaac06fdc0f312615f2e321e273"
    end

    go_resource "github.com/gogo/protobuf" do
      url "https://github.com/gogo/protobuf.git",
          :revision => "0394392b81058a7f972029451f06e528bb18ba50"
    end

    go_resource "github.com/influxdata/usage-client" do
      url "https://github.com/influxdata/usage-client.git",
          :revision => "6d3895376368aa52a3a81d2a16e90f0f52371967"
    end

    go_resource "github.com/jwilder/encoding" do
      url "https://github.com/jwilder/encoding.git",
          :revision => "4dada27c33277820fe35c7ee71ed34fbc9477d00"
    end
  end

  depends_on "go" => :build

  go_resource "collectd.org" do
    url "https://github.com/collectd/go-collectd.git",
        :revision => "9fc824c70f713ea0f058a07b49a4c563ef2a3b98"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/bmizerany/pat" do
    url "https://github.com/bmizerany/pat.git",
        :revision => "c068ca2f0aacee5ac3681d68e4d0a003b7d1fd2c"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
        :revision => "5cc10bbbc5c141029940133bb33c9e969512a698"
  end

  go_resource "github.com/davecgh/go-spew" do
    url "https://github.com/davecgh/go-spew.git",
        :revision => "5215b55f46b2b919f50a1df0eaa5886afe4e3b3d"
  end

  go_resource "github.com/dgryski/go-bits" do
    url "https://github.com/dgryski/go-bits.git",
        :revision => "2ad8d707cc05b1815ce6ff2543bb5e8d8f9298ef"
  end

  go_resource "github.com/dgryski/go-bitstream" do
    url "https://github.com/dgryski/go-bitstream.git",
        :revision => "7d46cd22db7004f0cceb6f7975824b560cf0e486"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
        :revision => "d9eb7a3d35ec988b8585d4a0068e462c27d28380"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
        :revision => "61d0deeb4ffcc167b2a1baa8efd72365692811bc"
  end

  go_resource "github.com/paulbellamy/ratecounter" do
    url "https://github.com/paulbellamy/ratecounter.git",
        :revision => "5a11f585a31379765c190c033b6ad39956584447"
  end

  go_resource "github.com/peterh/liner" do
    url "https://github.com/peterh/liner.git",
        :revision => "8975875355a81d612fafb9f5a6037bdcc2d9b073"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :revision => "274df120e9065bdd08eb1120e0375e3dc1ae8465"
  end

  go_resource "github.com/retailnext/hllpp" do
    url "https://github.com/retailnext/hllpp.git",
        :revision => "38a7bb71b483e855d35010808143beaf05b67f9d"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  def install
    ENV["GOPATH"] = buildpath
    influxdb_path = buildpath/"src/github.com/influxdata/influxdb"
    influxdb_path.install Dir["*"]
    revision = `git rev-parse HEAD`.strip
    version = `git describe --tags`.strip

    Language::Go.stage_deps resources, buildpath/"src"

    cd influxdb_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision} -X main.branch=master",
             "./..."
    end

    inreplace influxdb_path/"etc/config.sample.toml" do |s|
      s.gsub! "/var/lib/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/lib/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/lib/influxdb/wal", "#{var}/influxdb/wal"
    end

    bin.install "bin/influxd"
    bin.install "bin/influx"
    bin.install "bin/influx_tsm"
    bin.install "bin/influx_stress"
    etc.install influxdb_path/"etc/config.sample.toml" => "influxdb.conf"

    (var/"influxdb/data").mkpath
    (var/"influxdb/meta").mkpath
    (var/"influxdb/wal").mkpath
  end

  plist_options :manual => "influxd -config #{HOMEBREW_PREFIX}/etc/influxdb.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/influxd</string>
          <string>-config</string>
          <string>#{HOMEBREW_PREFIX}/etc/influxdb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/influxdb.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/influxdb.log</string>
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>10240</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("influxd config")
    inreplace testpath/"config.toml" do |s|
      s.gsub! %r{/.*/.influxdb/data}, "#{testpath}/influxdb/data"
      s.gsub! %r{/.*/.influxdb/meta}, "#{testpath}/influxdb/meta"
      s.gsub! %r{/.*/.influxdb/wal}, "#{testpath}/influxdb/wal"
    end

    begin
      pid = fork do
        exec "#{bin}/influxd -config #{testpath}/config.toml"
      end
      sleep 1
      output = shell_output("curl -Is localhost:8086/ping")
      sleep 1
      assert_match /X-Influxdb-Version:/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
