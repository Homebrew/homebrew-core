require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack."
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf.git",
      :tag => "1.3.0",
      :revision => "99099e8a5c160f7fa436c1b8a4dedfa5fb6e0c2f"

  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9527ed7c43a72e995867f2e602317fe943ad9fc3f1a8ec09d93ec8412ee9c0e1" => :sierra
    sha256 "b7a85a00281d8758b12ae4ec4db04b886429bba2dc74031aef671d2290dcef91" => :el_capitan
    sha256 "7dd8aa75f0c185444ad363845d758091d1387033c5c3d27a3c018542aece0c78" => :yosemite
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
