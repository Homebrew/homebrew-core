require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack."
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf.git",
      :tag => "1.3.3.4",
      :revision => "1bdfbbcc806b7957eeaf8b16507f518280e9afda"

  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4e98a6eb3ae3188e0baf1cec8bd39068c69fa8d1b479ccfdccaee6be61b4919" => :sierra
    sha256 "d7cd12d141bcb99078ff44464ed80eb61162ea38bbdd33be471c05847225a891" => :el_capitan
    sha256 "b84bcc4e17c3eb2fe72238099ed55861b02cfc1f9cfa856ba17492d3d673658f" => :yosemite
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
