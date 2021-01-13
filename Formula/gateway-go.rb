class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.95",
      revision: "19c8673a044deb3ec419e05b74b3fd745fe8678c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ab23366332d637ba358bca3fb740606ed8ea5f3d6d1f212a74e2c7a5795035e" => :big_sur
    sha256 "a04160bccb93bdf648d8291271254ccbcf3f31d760ae86c7b6f987c5a29bb20d" => :arm64_big_sur
    sha256 "6eb2f0a6f13d130d96c33de97ed7a355878ef7fd16d6891c00f5c927629feb6b" => :catalina
    sha256 "948c3d8af9a6fc2c48be298b4dbe4c88ab1739dff64f44fda2c8c075e01b9352" => :mojave
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
