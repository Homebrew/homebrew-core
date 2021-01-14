class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.18.1.tar.gz"
  sha256 "70484a888deef70e3a97a761f4541367688964a6c6f196f188e3adca4554b9e6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7afd213c5bb58dacb6e9f903c74e32f68756d1bcd3cf72377d4a469b1c4dc672" => :big_sur
    sha256 "f1fe6a1e2ef5d6c1d516b1b21e9da167171bfdb17dacc001ef1ac8acc005bc02" => :arm64_big_sur
    sha256 "fce7b7c1f414427214abe31e73dfbedb1d0164a246bd578430cf23775355bc69" => :catalina
    sha256 "860f6b4226c2dfab0e92b81b12c9bb952b8f5f83f6a270685880318ae04dbfc8" => :mojave
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
