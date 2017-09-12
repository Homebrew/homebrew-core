require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack."
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.3.8.1.tar.gz"
  sha256 "bfd95df17f3666fbdb8949de1f176cf12bb34f36e951da22989d77c4bcf01442"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3be5f5c156419fab685fd33c3bee3e7e6921c4928049ddeeff692cbdb9dfa499" => :sierra
    sha256 "b62566947aa3be4a26de1188cc5a5635fac4a6090128c43589b35524e9579b3e" => :el_capitan
    sha256 "4becd8b36bbd46f9b0b14024c3ae478d2dce00eedda7823a749404d38b459597" => :yosemite
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb" => :recommended
  depends_on "kapacitor" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Node.setup_npm_environment
    chronograf_path = buildpath/"src/github.com/influxdata/chronograf"
    chronograf_path.install buildpath.children

    cd chronograf_path do
      system "make", "dep"
      system "make", ".jssrc"
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
