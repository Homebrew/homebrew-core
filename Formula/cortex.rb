class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.8.1.tar.gz"
  sha256 "7a4184ce74f1cd2e9661d3d2bdb90c0c723e2b4183981242507bcb8d73764892"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a71509f73378c9e23587dbe58b27c93537e129d6f114441c6b994601acb38df2"
    sha256 cellar: :any_skip_relocation, big_sur:       "870deac9ba083e9603c34eaf6939f243a1e78adfbba84539bdab2c1b0207ead5"
    sha256 cellar: :any_skip_relocation, catalina:      "c9b65d151a373b7f12e99dbd95dac94c0634b464ba51debb6762abaacbeb1d1c"
    sha256 cellar: :any_skip_relocation, mojave:        "917fa83dd9c14205ab985837c952c06d3b6682b419f792a2618e97688ecc3e0d"
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
