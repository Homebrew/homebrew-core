class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.18.1.tar.gz"
  sha256 "70484a888deef70e3a97a761f4541367688964a6c6f196f188e3adca4554b9e6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4408d5fb3e13c4bb4d0dfd3c50bab7d9f0147be15932b41eff51e0948a61dfe5" => :big_sur
    sha256 "5a9a62b3064aec6ad5935a5e4f319c610b814e6017919df4b63159dd061659bc" => :arm64_big_sur
    sha256 "c92ee78d6c4bf1073a4c3b3f505ac8c0f5f075b34b827b4702be72403f954a4a" => :catalina
    sha256 "55f63c3c266ddb189d419ed9fc7919d658b93d96871e5358107daa473c441fb2" => :mojave
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
