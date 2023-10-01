class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1525cc9ea0055299ed20913bc2d8f4369e46b5c136eee7d85c44082969ad6313"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f01a65e9f6387deb4959d3fbe43f4985dce1dcb24c06cdc4648da18901a2e86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97316ae4e9b2ce6aa6854f1457bea44922c9d10968c093314755f82a58deeeea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a286ae105f386a0f6ef5d86e7843afe1677ddc4e41d14497115a965e3330bd"
    sha256 cellar: :any_skip_relocation, ventura:        "c1aeec1847818b768046ab5474cbf12edb556f08654e88d690e25bc96e5cdeb5"
    sha256 cellar: :any_skip_relocation, monterey:       "24d15d5cbcb6591bca969fad7665e7288c38809ec82389b1336ad224c4889180"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9445c7eabf7c8d62c87c1b29e488c6d57b8ac0f098cc37a9629968282142a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b644b053e0397c7a7cbffd41ac06bb00492e49cbda83132b170e24d5b07cb32c"
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
