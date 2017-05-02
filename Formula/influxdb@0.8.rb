class InfluxdbAT08 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdb.com/docs/v0.8/index.html"
  url "https://s3.amazonaws.com/get.influxdb.org/influxdb-0.8.8.src.tar.gz"
  sha256 "97fb5a4ffda1b333187ebd6449466d38d864686a3bd50a6c7bfb3deeae06cfae"
  revision 1

  bottle do
    cellar :any
    sha256 "f43b4821e4e0ec7d6d160762b7c189570069ba7f6d776cf8abcab1fd73277c65" => :sierra
    sha256 "5a9ea8001238a99223cd8bc6882118c033c60574f2993e2217cc7d1849e0b103" => :el_capitan
    sha256 "2b0ad3d8387c353e0a8d5c71b854e1fc464dbcd819750041ef8b4c09da4d9c04" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "leveldb"
  depends_on "rocksdb"
  depends_on "autoconf" => :build
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build
  depends_on "gawk" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath
    Dir.chdir File.join(buildpath, "src", "github.com", "influxdb", "influxdb")

    flex = Formula["flex"].bin/"flex"
    bison = Formula["bison"].bin/"bison"

    inreplace "configure", "echo -n", "$as_echo_n"

    system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}", "--with-rocksdb"
    system "make", "parser", "protobuf"
    system "go", "build", "-tags", "leveldb rocksdb", "-o", "influxdb", "github.com/influxdb/influxdb/daemon"

    inreplace "config.sample.toml" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb08/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb08/raft"
      s.gsub! "/tmp/influxdb/development/wal", "#{var}/influxdb08/wal"
      s.gsub! "influxdb.log", "#{var}/influxdb08/logs/influxdb.log"
    end

    bin.install "influxdb" => "influxdb"
    etc.install "config.sample.toml" => "influxdb.conf"

    (var/"influxdb08/data").mkpath
    (var/"influxdb08/raft").mkpath
  end

  plist_options :manual => "influxdb -config=#{HOMEBREW_PREFIX}/etc/influxdb.conf"

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
          <string>#{opt_bin}/influxdb</string>
          <string>-config=#{etc}/influxdb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/influxdb08</string>
        <key>StandardErrorPath</key>
        <string>#{var}/influxdb08/logs/influxdb.stderr.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/influxdb08/logs/influxdb.stdout.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/influxdb", "-v"
  end
end
