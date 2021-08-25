class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.20.0.tar.gz"
  sha256 "a3873f9bf180184c7b9cad0c6106daea9daea47643c130dc29b6d0a8206e9bda"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78b12ac7cc6d02b0e05d7f39bc1dee7b050c652a3412b12bc733aac1b667af5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7910799d97cf7a7d161b026a5d106a2432e96eb239194a7fed9d903e77327f1"
    sha256 cellar: :any_skip_relocation, catalina:      "e4e78756580908dab7fccc59ac3a653f9a821630bba4f1e34e50b241b70a8d13"
    sha256 cellar: :any_skip_relocation, mojave:        "81b40b5fb6bd5ddb0a16924999cdb7721db1d6cc9c82edb9243ecee253054223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9f1a92823ccb48450865fbb02d37bdb20387367bd669c1bc6f839aa0552d79"
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
