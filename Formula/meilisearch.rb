class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.19.0.tar.gz"
  sha256 "0c6263c891e8e852ce7b9ac2af2fdd0f2931e9c0d214827f2cae1a3c8593605b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6bafaf6fda9387ed5ae00c5e120467a83dd857177ab3debf7fbcdebf6c34285"
    sha256 cellar: :any_skip_relocation, big_sur:       "288c51d44f1b88d3b89b412a14769416c97e292c70c52cd5d3d14aca5a96545c"
    sha256 cellar: :any_skip_relocation, catalina:      "14d58488784c2a5655233ed3d7891780019b9f0210e4f9ed3da607da4ac2d40f"
    sha256 cellar: :any_skip_relocation, mojave:        "aadd4813419198bd9beed09373430e8d2a781e88e8a93696b0f02a214c076d96"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
      system "cargo", "install", *std_cargo_args
    end
  end

  plist_options manual: "meilisearch"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/meilisearch</string>
            <string>--db-path</string>
            <string>#{var}/meilisearch/data.ms</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/meilisearch.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/meilisearch.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep(3)
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
