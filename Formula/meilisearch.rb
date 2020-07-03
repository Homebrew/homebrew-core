class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.12.0.tar.gz"
  sha256 "69dc0492083b26c365954b9d65d8c3f601b6b4b11a45f789a70e2413b82a8429"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4da6b5e4f556b575af454d45e5879e2138c70424ad57aa28092a4b61c013ff9" => :catalina
    sha256 "cc03a32a747f4a592cc674b70076c7aa8b3562b5e245e50c8725495d14d8c5aa" => :mojave
    sha256 "1b436742cf77b5ba7bfce1ff772e0642a9015b2f057c0fc32a3603ebe2f1a80a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
      system "cargo", "install", *std_cargo_args
    end
  end

  plist_options :manual => "meilisearch"

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
