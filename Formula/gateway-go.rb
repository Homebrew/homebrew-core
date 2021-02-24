class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.96",
      revision: "aad056db6539a2314b59a5ebd06efc3c65cd5467"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f178d9f666136307323c4ac573a34c99b24fe4594b0a5e64a1cf9cf1caf7e378"
    sha256 cellar: :any_skip_relocation, big_sur:       "afbc093d6c60b18ccdc2b211820c2d9e49d3b2b607154e354739da76a1d22f85"
    sha256 cellar: :any_skip_relocation, catalina:      "b7a2b1b82cf6727e4c4dbba12ac19eb87f462221285431382da1f1de15bcf08b"
    sha256 cellar: :any_skip_relocation, mojave:        "92eabc9c84a24d24ca5432d1a02edde85834bc180acb543ba70f5ea95c3ba271"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args
    (etc/"gateway-go").install "gateway-go.yaml"
  end

  plist_options manual: "gateway-go -c #{HOMEBREW_PREFIX}/etc/gateway-go/gateway-go.yaml"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/gateway-go</string>
            <string>-c</string>
            <string>#{etc}/gateway-go/gateway-go.yaml</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/gateway-go.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/gateway-go.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_predicate testpath/"gateway.yml", :exist?
  end
end
