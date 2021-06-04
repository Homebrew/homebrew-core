class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.2.1.tar.gz"
  sha256 "4801a9418c913bcca5e597d09f0f7ce1f5a7ce879f8dba3e8fe86057cb592bcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "428bba8b394ff5df1d24f9cdc7442b0af94ce6744768d3155ef78e9917e54428"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f1d035a3048b1b7c6a8da97c402b46e14749cb2bbeed9da0a1b69165af04454"
    sha256 cellar: :any_skip_relocation, catalina:      "5ad6744fff9fc86d40bdfe9f8e8fbfd8c61a2dbb6b4dcb4e4fa84604fbf0d875"
    sha256 cellar: :any_skip_relocation, mojave:        "a74082f6653808f5b4d6180678223c8b2ddb9b8a288b31964ba3d8a17db2f25b"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  plist_options manual: "loki -config.file=#{HOMEBREW_PREFIX}/etc/loki-local-config.yaml"

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
            <string>#{opt_bin}/loki</string>
            <string>-config.file=#{etc}/loki-local-config.yaml</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/loki.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/loki.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
