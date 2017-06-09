require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack."
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf.git",
      :tag => "1.3.2.1",
      :revision => "6863a3617e9fa0c8db8e81db163ca7464b75bf97"

  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d3460d2be945b969f66216ac7ea08e48b4c3026eaf730e58904583e7c7cd552" => :sierra
    sha256 "dc6f30722ed9fa65937f8fae33c50324c9a658a870cf76c6db5c91ea658124bb" => :el_capitan
    sha256 "bd272392056f3e48c84e0f85aa5fd1636e773d7ad57fbbf8c67b45cb239485b0" => :yosemite
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb" => :recommended
  depends_on "kapacitor" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    chronograf_path = buildpath/"src/github.com/influxdata/chronograf"
    chronograf_path.install buildpath.children

    cd chronograf_path do
      system "make", "dep"
      cd "ui" do
        system "npm", "install", *Language::Node.std_npm_install_args(libexec)
        system "npm", "run", "build"
        touch ".jssrc"
      end
      system "make", ".bindata"
      system "make", "chronograf"
      bin.install "chronograf"
    end
  end

  plist_options :manual => "chronograf"

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
          <string>#{opt_bin}/chronograf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/chronograf.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/chronograf.log</string>
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
