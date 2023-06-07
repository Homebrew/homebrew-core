class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.2.0.tar.gz"
  sha256 "0f10c5939fefa7bd6e77fdbbdc21620e6d8dc11dbf3d4f65fa213a23ae24753d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e919f19496b39fa0a3b6396f74847e417ca15ffadffc9e43cd121ba174e57656"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4233bcedd57ca7c797eba80651e39e24380e36c1101441ebeadbcfc6652205d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01c0190ef2d1f4209c4b7682f41c7f0f6f9047e77843893c681ff897fd7ac274"
    sha256 cellar: :any_skip_relocation, ventura:        "ae30df38497967d906f617edd882bd45fc2ed53d845acfb7cb6fe2e7125c44cf"
    sha256 cellar: :any_skip_relocation, monterey:       "6eef1c77d8f7f234585f47dabd9a906b1137d4293168e0df79b488926af81885"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a7597593446dcbbae5ce40ffb2bc143c4788ec51c9f09d037f422c76436d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ba2279f46249f8ecca66599ce52e0a002f40c050056db462cc1d4f4c0ffeac"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
