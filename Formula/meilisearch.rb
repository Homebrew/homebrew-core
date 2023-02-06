class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.0.0.tar.gz"
  sha256 "390cf67cc2769fd4b3208ba187f8173e1604d5e48b29525fe171a3e36ae83672"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ef636375d7870092fde6e2dd5c5b0af2f9c76eefd5cd8e8b2121e432dd85bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be7f7920b30cc928e182b16e578f880b4924bcdff93b0e33e123b92936c2b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f976c7cd7071cdab1ada9d0e74e89fa2c9f3080abc91997f313285b389771fd"
    sha256 cellar: :any_skip_relocation, ventura:        "381ad31076be513886d8bfed376924f42b15adf39ef83d33578a07123b6bb761"
    sha256 cellar: :any_skip_relocation, monterey:       "c93f9465ac59352da2d19b537ab2a28c4c46debb5529af2b8c49fd94ed7f09db"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3902b456d114e0ad12a96d6e84354de3f929d0f89f526370fb4388eaa335db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40dcda7c0a9540e10dd37c5b7deefb3392d60b71c11cee02996e6cd9b452140e"
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
