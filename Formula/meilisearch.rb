class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.26.1.tar.gz"
  sha256 "d5df8df24967b8f68b11c03cd8d0efd65d7284733fd54c6df842b9f19516d4a4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "265c6ee0ae6ade20d94587a5274dc2646b9aa465d0479dd3295a728c9bc8e2da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d1b4fd908da51bc3a927a527697b7a52ccc683a00bcdf54995aa30b8b271bde"
    sha256 cellar: :any_skip_relocation, monterey:       "9662788067ceb52acc00e8438f35272bcc5085d903a1afbfedaafa5c0f41c403"
    sha256 cellar: :any_skip_relocation, big_sur:        "8445b52b2d2ace8ad7d2290684945e71f3bed7571fa17e07b1d925b78f8385da"
    sha256 cellar: :any_skip_relocation, catalina:       "8eba0bb2b788e1df1a4fba3adc471ba28f83e7ff2bccc965d597e3e6dbe6c3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d58c854bb3e7ad0e1a44cabdb18666ff3849c277d539b77df4540dd57ccb05"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
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
    sleep(3)
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
