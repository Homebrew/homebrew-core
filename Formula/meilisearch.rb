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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b5020b68bc66643c3e2d5cd80d494253eef6d0a16d457d8c95b1e904c1e667"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acb24a0326ce20d6d4922132e24572714d853f8e3346efe16a7a0e296683f141"
    sha256 cellar: :any_skip_relocation, monterey:       "98b7b7d6ce88e1ad59e9d2ae6293872d9c5599ffd145724a0d0449cf62c941c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "116bcb7d92edc62ef4dac7fbf415ad7a4e2931bc5f87ecd96cb6ca7d6a409321"
    sha256 cellar: :any_skip_relocation, catalina:       "4723a67f3e7a5d6ccfd7aff898f6a8a1d765688eeffb19e30d5222ad54773074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "615aff1d2d2e4fd9c77f022abce086773e8b60c9e5abff0962cdafa23e55b00b"
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
