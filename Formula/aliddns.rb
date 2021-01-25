class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.8",
      revision: "9f286a510522a4df83319c822805e7b1a6f7ca64"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b91312e27065e23f3444144d9e1dddcad8337c6c60d3e597235089befb50dcc7" => :big_sur
    sha256 "868f0972a9c769d8854cf4b9d86b0c1ac75c542764054f867d909ddc9b091b1d" => :catalina
    sha256 "3eaeedd4962169e2ac8660fdccfa628c389e01e00b9435dda1adebdb18488a70" => :mojave
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
    pkgetc.install "aliddns.yaml"
  end

  plist_options manual: "aliddns -c #{HOMEBREW_PREFIX}/etc/aliddns/aliddns.yaml"

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
            <string>#{opt_bin}/aliddns</string>
            <string>-c</string>
            <string>#{etc}/aliddns/aliddns.yaml</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/aliddns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/aliddns.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aliddns -v 2>&1")
    assert_match "config created", shell_output("#{bin}/aliddns init --config=aliddns.yml 2>&1")
    assert_predicate testpath/"aliddns.yml", :exist?
  end
end
