require "language/go"

class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
    :tag => "0.13.0",
    :revision => "e64b52e05dd7c888fe0549a06db3cac118a63dec"

  head "https://github.com/influxdata/kapacitor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d53415ad2d106dd8e51a3a63b33a3bb35aae680145bd7d4708f5d32100dbcae2" => :el_capitan
    sha256 "a80e7aebfa3b896aa06136d7f373cc0302b6e7ea22c81d084a5eb79c2caf2610" => :yosemite
    sha256 "eb5b3ece7565870d1e2a9d18a35da48e12a0b1a0ac88d062fa3b39dc47451005" => :mavericks
  end

  depends_on "go" => :build
  depends_on "influxdb"

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
    :revision => "144418e1475d8bf7abbdc48583500f1a20c62ea7"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
    :revision => "32cd0c5b3aef12c76ed64aaf678f6c79736be7dc"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
    :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
    :revision => "4365f750fe246471f2a03ef5da5231c3565c5628"
  end

  go_resource "github.com/gorhill/cronexpr" do
    url "https://github.com/gorhill/cronexpr.git",
    :revision => "f0984319b44273e83de132089ae42b1810f4933b"
  end

  go_resource "github.com/influxdata/influxdb" do
    url "https://github.com/influxdata/influxdb.git",
    :revision => "f232c0548611371929e8a2cc082e29ae2d4a4326"
  end

  go_resource "github.com/influxdb/usage-client" do
    url "https://github.com/influxdb/usage-client.git",
    :revision => "475977e68d79883d9c8d67131c84e4241523f452"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
    :revision => "b5dddb1667dcc1e6355b9305e2c1608a2db6983c"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
    :revision => "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
    :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/naoina/toml" do
    url "https://github.com/naoina/toml.git",
    :revision => "751171607256bb66e64c9f0220c00662420c38e9"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
    :revision => "b43df972fb5fdf3af8d2e90f38a69d374fe26dd0"
  end

  go_resource "github.com/serenize/snaker" do
    url "https://github.com/serenize/snaker.git",
    :revision => "8824b61eca66d308fcb2d515287d3d7a28dba8d6"
  end

  go_resource "github.com/shurcooL/go" do
    url "https://github.com/shurcooL/go.git",
    :revision => "377921096a5b956ff0a2cd207bf03a385a3af745"
  end

  go_resource "github.com/shurcooL/markdownfmt" do
    url "https://github.com/shurcooL/markdownfmt.git",
    :revision => "45e6ea2c4705675a93a32b5f548dbb7997826875"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
    :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "1f4a1643a57e798696635ea4c126e9127adb7d3c"
  end

  go_resource "github.com/twinj/uuid" do
    url "https://github.com/twinj/uuid.git",
    :revision => "89173bcdda19db0eb88aef1e1cb1cb2505561d31"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "b8a0f4bb4040f8d884435cff35b9691e362cf00c"
  end

  go_resource "gopkg.in/gomail.v2" do
    url "https://gopkg.in/gomail.v2.git",
    :revision => "42916101524810bd3aed9a8b25e6bb58d8e3af82"
  end

  def install
    ENV["GOPATH"] = buildpath
    kapacitor_path = buildpath/"src/github.com/influxdata/kapacitor"
    kapacitor_path.install Dir["*"]
    revision = `git rev-parse HEAD`

    Language::Go.stage_deps resources, buildpath/"src"

    cd kapacitor_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision}",
             "./..."
    end

    inreplace kapacitor_path/"etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    bin.install "bin/kapacitord"
    bin.install "bin/kapacitor"
    etc.install kapacitor_path/"etc/kapacitor/kapacitor.conf" => "kapacitor.conf"

    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  plist_options :manual => "kapacitord -config #{HOMEBREW_PREFIX}/etc/kapacitor.conf"

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
          <string>#{opt_bin}/kapacitord</string>
          <string>-config</string>
          <string>#{HOMEBREW_PREFIX}/etc/kapacitor.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kapacitor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kapacitor.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! /\[\[influxdb\]\]\n  enabled = true/m, "[[influxdb]]\n  enabled = false"
      s.gsub! %r{data_dir = "/.*/.kapacitor}, "data_dir = \"#{testpath}/kapacitor"
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
    end

    (testpath/"influxdb-config.toml").write shell_output("influxd config")
    inreplace testpath/"influxdb-config.toml" do |s|
      s.gsub! %r{/.*/.influxdb/data}, "#{testpath}/influxdb/data"
      s.gsub! %r{/.*/.influxdb/meta}, "#{testpath}/influxdb/meta"
      s.gsub! %r{/.*/.influxdb/wal}, "#{testpath}/influxdb/wal"
    end

    pid = fork do
      exec "#{bin}/influxd -config #{testpath}/influxdb-config.toml"
    end
    sleep 5

    pid = fork do
      exec "#{bin}/kapacitord -config #{testpath}/config.toml"
    end
    sleep 2

    begin
      shell_output("#{bin}/kapacitor level info")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
