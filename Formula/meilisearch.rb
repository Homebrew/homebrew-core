class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.29.0.tar.gz"
  sha256 "45ce5ba49984258763d7cc4fd33ba407fcbeb2dcb5c36b23e6c8dbb3e1684bde"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2027a7864a6450c8f3701d5507a227d6fef44f43d1839b6866fdc41bff26920a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64c71a04c60c6b1bf67ffebbbf9718d9602140d8d58aa8fc51459db19de51c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "da97e122c1666e18840ae55e0f66c214e05ed4ff09e52fa937ca0b59c15eca7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f02532b74b9c4d734c77a86a0a34a1cdc82e5a97b018063b33d4f65cb7e0b615"
    sha256 cellar: :any_skip_relocation, catalina:       "f437746197abecfe37fcee6cd553c7b696d034dcca5fe7e684faf63707a73cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21b159c95ff8c3debf6f971daf92d4fbac1bf3ce7014250e94fd2a9d8033f52"
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
