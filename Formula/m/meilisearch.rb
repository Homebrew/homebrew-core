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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4bdc30e814a255508ef2ff2c45ffc5f157eabd8e7941a70da15d189cbec68d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd999717ecb386c3962fb40cace1797a8606ca6a66d042f9e64e53a03e802fc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52448c4cc8d1b38d46db55eea31597dd5dd8bb57e8a7fc3c3e807f69f2edebec"
    sha256 cellar: :any_skip_relocation, ventura:        "3ac014500b02736208195a56bce5eedb97d968900d55a67c0520561d65b4d489"
    sha256 cellar: :any_skip_relocation, monterey:       "3efb1637e02d90a974a1aa9ab72b72dc7295811ef7442a2fe69a5feff4c93e68"
    sha256 cellar: :any_skip_relocation, big_sur:        "fef534525b710122bd18e0c885145b9dcc1784c51e4f0c94f8c1d59567c96783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e51f5c4e794ad7f443c9ed8f5127cd8dda0e770540f1793f03377775bad757"
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
