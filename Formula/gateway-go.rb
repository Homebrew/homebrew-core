class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.97",
      revision: "45fd6dda8e885293f622c63577bd601f03e4c7c0"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68a83d86168de5770073aade23a9eca36f7c45af46ebaea6bf467caf08bd6161"
    sha256 cellar: :any_skip_relocation, big_sur:       "31a5cc63190a8e757c9a7ec84f4ed0b3ba0252d3ee479ee795d3a9fd3c622257"
    sha256 cellar: :any_skip_relocation, catalina:      "31d0a5a6767e70634c0c2b3d077c0de1533ff4655a1cf14e933cedfdc3e0f993"
    sha256 cellar: :any_skip_relocation, mojave:        "81a1ec5d087317840427958e1a77ce1a8dfd492864f427a624e4a980d9e2b85d"
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
