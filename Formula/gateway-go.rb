class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.95",
      revision: "19c8673a044deb3ec419e05b74b3fd745fe8678c"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0062a8e104361cc6206e962c581b1d2f20dfe136c5088940841bd1b4ff09734e" => :big_sur
    sha256 "98534050956e22d423d5450968b2319ae38478b9881ebca0a81a3d76dcfd57ad" => :arm64_big_sur
    sha256 "bdfb63466aee4c484ec01e3345c1804fbdb52ac9a40caa175bcb01b9fc7f4de1" => :catalina
    sha256 "93fe2255aa6f888afdf45225c76bb74481cb0c8dd3cba4d243d45e518db933ae" => :mojave
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
