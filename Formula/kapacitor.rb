class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      :tag      => "v1.5.2",
      :revision => "3086452d00830e01d932838d8c6d1df818648ad3"
  head "https://github.com/influxdata/kapacitor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44ba2e5cd5045717759cde7c82e7752eca277f80a49ffc653ef35819fd153678" => :mojave
    sha256 "5f982cb2044276f9041453ef8a0b15120bf1f180eb5fff9794173d2d5a6027fc" => :high_sierra
    sha256 "09136286c7d4c14c9bdc8a684e6d45ffff0750049fe30dd75dd45cbbb9e19e53" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    kapacitor_path = buildpath/"src/github.com/influxdata/kapacitor"
    kapacitor_path.install Dir["*"]
    revision = Utils.popen_read("git rev-parse HEAD").strip
    version = Utils.popen_read("git describe --tags").strip

    cd kapacitor_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision}",
             "./cmd/..."
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

  def plist; <<~EOS
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
    (testpath/"config.toml").write shell_output("#{bin}/kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! /disable-subscriptions = false/, "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, "#{testpath}/kapacitor/kapacitor.db"
    end

    begin
      pid = fork do
        exec "#{bin}/kapacitord -config #{testpath}/config.toml"
      end
      sleep 2
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
