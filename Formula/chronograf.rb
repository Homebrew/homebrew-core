require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.7.5.tar.gz"
  sha256 "53c458b91982b679bcfee400155c9978c64a6c620846e366326dfc65885fbf11"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a99a6c673c4d14d9800b90697a4df81d4ea8171c4f633a5960d0bc2cd8d53ae6" => :mojave
    sha256 "be2b0f7d3c94ac052e1afd571a9857cd6dd7805d13a09849206e60b4d2c79253" => :high_sierra
    sha256 "6ad031bd62b46af55cf9f8661815c3b7c29704664be12e1119bb012343ec64cb" => :sierra
  end

  depends_on "go" => :build
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

    # fixes yarn + upath@1.0.4 incompatibility, remove once upath is upgraded to 1.0.5+
    Pathname.new("#{ENV["HOME"]}/.yarnrc").write("ignore-engines true\n")

    cd chronograf_path do
      system "make", "dep"
      system "make", ".jssrc"
      system "make", "chronograf"
      bin.install "chronograf"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "chronograf"

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
