require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://www.influxdata.com/time-series-platform/chronograf/"
  url "https://github.com/influxdata/chronograf.git",
      :tag => "1.1.0-beta6",
      :revision => "16108f0321ee126fda5ed2a384b005e65054393e"

  head "https://github.com/influxdata/chronograf.git"

  depends_on "gdm" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :tag => "v3.0.5",
        :revision => "1c1928d3b62dc79f5b35c32ae372a5fe69e9b4f1"
  end

  def install
    ENV["GOPATH"] = buildpath
    chronograf_path = buildpath/"src/github.com/influxdata/chronograf"
    chronograf_path.install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    cd chronograf_path/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end

    cd chronograf_path do
      revision = `git rev-parse HEAD`.chomp
      version = `git describe --tags`.chomp
      system "gdm", "restore"
      system "go", "generate", "-x", "./dist"
      system "go", "generate", "-x", "./canned"
      system "go", "generate", "-x", "./server"
      system "go", "build", "-o", "chronograf",
             "-ldflags", "-s -X main.Version=#{version} -X main.Commit=#{revision}",
             "./cmd/chronograf/main.go"
      bin.install "chronograf"
    end
    (prefix/"share/chronograf/canned").mkpath
  end

  plist_options :manual => "chronograf --bolt-path #{HOMEBREW_PREFIX}/lib/chronograf/chronograf-v1.db --canned-path #{HOMEBREW_PREFIX}/usr/share/chronograf/canned"

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
          <string>#{opt_bin}/telegraf</string>
          <string>--bolt-path</string>
          <string>#{HOMEBREW_PREFIX}/lib/chronograf/chronograf-v1.db</string>
          <string>--canned-path</string>
          <string>#{HOMEBREW_PREFIX}/usr/share/chronograf/canned</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/telegraf.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/telegraf.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/chronograf"
      end
      sleep 1
      output = shell_output("curl -s 0.0.0.0:8888/chronograf/v1/")
      sleep 1
      assert_match %r{/chronograf/v1/layouts}, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
