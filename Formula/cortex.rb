class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.6.0.tar.gz"
  sha256 "17dd427a676eb2af52a5d758397a4c384fe73e2e1379122b0a3dc6e36b378de4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b2b1578fbda810919635eb9c5e6cd26c9826d9b66811a2408f9459f4428e6c52" => :big_sur
    sha256 "a15b4792c7334365dbda6493e87214b2a7b091c5f6342bdb175ca6e44688bb4c" => :arm64_big_sur
    sha256 "b89466af24dab8ef0e913462515d6bd0a1673c11d8eb8b0e1712212c1cb25dc1" => :catalina
    sha256 "f0cf729caf7dc1b9cd19e2f4ac12bc38961f36f76d2ddbfac4365912dd33d8c4" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cortex"
    cd "docs/configuration" do
      inreplace "single-process-config.yaml", "/tmp", var
      etc.install "single-process-config.yaml" => "cortex.yaml"
    end
  end

  plist_options manual: "cortex -config.file=#{HOMEBREW_PREFIX}/etc/cortex.yaml"

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
            <string>#{opt_bin}/cortex</string>
            <string>-config.file=#{etc}/cortex.yaml</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/cortex.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/cortex.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    cp etc/"cortex.yaml", testpath
    inreplace "cortex.yaml" do |s|
      s.gsub! "9009", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"cortex", "-config.file=cortex.yaml", "-server.grpc-listen-port=#{free_port}" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/services")
    assert_match "Running", output
  end
end
