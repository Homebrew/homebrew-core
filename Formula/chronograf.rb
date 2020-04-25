require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.8.3.tar.gz"
  sha256 "743cfec5eb1fce9f77e93d5bcf2e9bbceab6ebc035907354713ea25c9b40024f"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ce63c15dbc1f0b1e8c98a73f80ffaad51e60169b752324dea24b0479f146a1a" => :catalina
    sha256 "df8e6274b193e2f04385d3c9659141dcfae3ed9502808e1946e9dcc74a45bcbe" => :mojave
    sha256 "7ed386bd51753ee5ca9999809c4a0bba47cd7efee1885df66a39fd1d2790630a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Node.setup_npm_environment
    chronograf_path = buildpath/"src/github.com/influxdata/chronograf"
    chronograf_path.install buildpath.children

    cd chronograf_path do
      cd "ui" do # fix node 12 compatibility
        system "yarn", "upgrade", "parcel@1.11.0", "node-sass@4.12.0"
      end
      system "make", "dep"
      system "make", ".jssrc"
      system "make", "chronograf"
      bin.install "chronograf"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "chronograf"

  def plist
    <<~EOS
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
    port = free_port
    pid = fork do
      exec "#{bin}/chronograf --port=#{port}"
    end
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match %r{/chronograf/v1/layouts}, output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
