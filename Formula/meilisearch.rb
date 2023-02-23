class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.0.2.tar.gz"
  sha256 "05a38584773121398c6dfe64ef28ad3cae5a973904a5b98c206c9ab2a638aa34"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85d0968c2da9f39537d14163cc5eac5d8396f984a36c3fe75ec92930b88a0b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50db5f6532c03f7760663e4629ce1ec6c2c280df0035f6474b52fe42b86dd9fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb5e684a59daade35ef488091affed2aed481cf9d5617b8feb1c8f2d5c0cb755"
    sha256 cellar: :any_skip_relocation, ventura:        "88ab96b62e3ae40136fd3e7ecfe4ce37c55adcd47ad796e25f0324e5510e8e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "5a0fc919904039eb65708ad12235d938d015cc5d6e6c66c1dd127ab59a1f64e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb4db11a2bf0c69ce2e5049bb8f889aaf00ce12fde890e6d8f6e2787479dc856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db03da0c5de3957fd06dd7a3b0f2a06f313f00e3b9a38bcc1bb6f503afc1560"
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
