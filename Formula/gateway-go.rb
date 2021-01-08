class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.93",
      revision: "05cce6460a3277183bd3aa725f867f1daad15426"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "930cf80740aef58a36aa4de90931f07195128dbaa90f158b0734e0fa6de14658" => :big_sur
    sha256 "444eb1ff982c8e9e02f7fedc7c5d237ec0fc65d84bff5ec2bceb7191f5efb9bc" => :arm64_big_sur
    sha256 "a7f46eb4d8257be3f24c84f971fa6d95582172abda87aeb1e3f6ffb1d85752e6" => :catalina
    sha256 "083175571da3825c9c159c03a7028b01aa065baca9aeda5f0f6ef9916e2c8f74" => :mojave
    sha256 "6c6e994988b6f09dc0ff80d51a45b14153834f573746f726c3d00585b1869e8d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    (etc/"gateway-go").mkpath
    system "go", "build", "-mod=vendor", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
    etc.install "gateway-go.yaml" => "gateway-go/gateway-go.yaml"
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
