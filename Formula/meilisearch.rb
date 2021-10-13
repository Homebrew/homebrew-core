class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.23.1.tar.gz"
  sha256 "3c34ecd7a22cb67480faf1db68589e9a5523be01c3335c9014eb45c2cbc575d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c1287b893ae845b030075f6d38090a359178350aa05466c7b0ca7cf4dd44aca"
    sha256 cellar: :any_skip_relocation, big_sur:       "5493772e502961c01a1e4d7aed6adefc63d627f19c264911bb9e13ae215ed9bd"
    sha256 cellar: :any_skip_relocation, catalina:      "020fe52571b26866e7af1b5f5b64501342670d80aaf09f25f8027d3e45c84271"
    sha256 cellar: :any_skip_relocation, mojave:        "8fb9e274d85b3190c44af2da178acc345ad2bc691d02144c9a77bf66236aeab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd74829a0c90ca96517d6cac2ac254098d95d06a92e88cdaa458992076ad8394"
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
