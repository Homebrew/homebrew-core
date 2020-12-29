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
    sha256 "337c92f3ba0fc8bb6401ba03fcd6d185ab14fe6042ff3f06081d87af5989b585" => :big_sur
    sha256 "afc9bc1823e8457603f3bce88be99e8dc5ba6c0f87084036e5ba30b89a911bf0" => :arm64_big_sur
    sha256 "7b048addb9cae0bcc4d4624c22d45ea94447317407836a11198e46d078351513" => :catalina
    sha256 "8791d3c130d3ca1c6fd088ea07f585716b8d33b1f4024e3bdd247f00aa5a2f5d" => :mojave
    sha256 "91b1dae9d8a3d08e5d0a31315a4a37f24d2bd4178546d7ceddfe22810b6b8253" => :high_sierra
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
