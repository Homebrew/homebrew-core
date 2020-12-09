class Ooniprobe < Formula
  include Language::Python::Virtualenv

  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.1.0.tar.gz"
  sha256 "daa3878737df32565192ea2010151183a45125ee1efced1bfeef21be1e9a54c9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "9a5d8c8b6bda3609642113631ba7c39b2cbf4fc27b09bd4b2fccc832befdd3e5" => :catalina
    sha256 "e8e120b4342f22d48efbcfa45cde2faa28c9edd045121373f3b2ba8349e1d6fc" => :mojave
    sha256 "3e13549c0175e9f3167f24526ed0c45bd7096b84c0360042654be9b4dff980f7" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    (buildpath/"src/github.com/ooni/probe-cli").install buildpath.children

    cd "src/github.com/ooni/probe-cli" do
      system "./build.sh macos"
      bin.install "CLI/darwin/amd64/ooniprobe"
    end
    ooni_home = Pathname.new "#{var}/ooniprobe"
    ooni_home.mkpath
  end

  def post_install
    ENV["OONI_HOME"] = "#{HOMEBREW_PREFIX}/var/ooniprobe"
    system bin/"ooniprobe", "onboard", "--yes"
  end

  def caveats
    <<~EOS
      By enabling the homebrew service you will not be shown the informed consent.

      WARNING:

      • OONI Probe will likely test objectionable sites and services
      • Anyone monitoring your internet activity (such as your government
        or Internet provider) may be able to tell that you are using OONI Probe
      • The network data you collect will be published automatically

      To learn more about the risks see:
          https://ooni.org/about/risks
    EOS
  end

  plist_options manual: "ooniprobe run"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>

          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>

          <key>EnvironmentVariables</key>
          <dict>
            <key>OONI_HOME</key>
            <string>#{HOMEBREW_PREFIX}/var/ooniprobe</string>
          </dict>

          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/ooniprobe</string>
              <string>--log-handler=syslog</string>
              <string>run</string>
              <string>unattended</string>
          </array>

          <key>StartInterval</key>
          <integer>86400</integer>

          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}/var/ooniprobe</string>
      </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "_version": 3,
        "_informed_consent": true,
        "sharing": {
          "include_ip": false,
          "include_asn": true,
          "upload_results": false
        },
        "nettests": {
          "websites_url_limit": 1,
          "websites_enabled_category_codes": []
        },
        "advanced": {
          "send_crash_reports": true,
          "collect_usage_stats": true
        }
      }
    EOS

    mkdir_p "#{testpath}/ooni_home"
    ENV["OONI_HOME"] = "#{testpath}/ooni_home"
    Open3.popen3(bin/"ooniprobe", "--config", testpath/"config.json", "run", "websites", "--batch") do |_, _, stderr|
      stderr.to_a.each do |line|
        j_line = JSON.parse(line)
        assert_equal j_line["level"], "info"
      end
    end
  end
end
