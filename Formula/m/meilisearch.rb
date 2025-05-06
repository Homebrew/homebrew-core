class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "0909838996e0a0e3bff84d1c60d1272401732b58136267542956699cd156708b"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f633aae34dcbf8153a7b346e5b2c3534261ac930f96d4a8dfca2ab2f86ebfcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2efc9b49afe34f29b010f24e26dcc850bff34a9cb2040387c3bb07fcf253af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43eb911e1e5ad829ae812f5f3907cc20f9d491d9808d3d471472253fbc3becb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccb45d33442cd73ab5c8fb841629e365536b6d4212513cf601a588d2c7eca93c"
    sha256 cellar: :any_skip_relocation, ventura:       "1d30788f0a9c4420b82fed791de43a86d19288ba598052d0f681ced30c20480a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df9a514e60ce18d8cc04a1afb7a4297e96079a2741b83a831666e7576962039d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190c237be9d9f69bd0dce54d36d3fadc7778d1d80ea3561bce05977c848be5a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
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
