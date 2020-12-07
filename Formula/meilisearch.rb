class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.17.0.tar.gz"
  sha256 "8729a73a285ab1d804e699ec8e8792f53f5b86a266bb87367c723345a8cf537c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "912506c6fb8d8eb0ff0709a5966902b7b43dcff6de498a1d67888f90124afd11" => :big_sur
    sha256 "5a0d20f97571361cdb65f478ba68e0a08027e411d0f5c7998c260ce5960a8ac5" => :catalina
    sha256 "ee525f52028817e48bbd0e7a7f8cc704bb9cd2847c02b5f4c8683900ea956ad7" => :mojave
    sha256 "df22093a58e711fbf3700ca7c00050831be3a0a3532dfbb2e86caafcf1b865be" => :high_sierra
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
