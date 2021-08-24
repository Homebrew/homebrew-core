class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.20.0.tar.gz"
  sha256 "a3873f9bf180184c7b9cad0c6106daea9daea47643c130dc29b6d0a8206e9bda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98f84b8cc9e1a98ae5fd209602079c2877655fed22f357c8d87f04751286cc3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "55a6830696ba4b3fd3801be99180c95305e8b8d6c88e222068be8ecf528a1ca4"
    sha256 cellar: :any_skip_relocation, catalina:      "2b6572a94c06b50750ecf5e9d2a39ec2fe502213f12c8efe10e0dbbba4b003af"
    sha256 cellar: :any_skip_relocation, mojave:        "87df8e1be817662fce7d9a570bb1d0482edfe3338c7e642b2f2603436e2be236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82957fd490d1cf26a896dab2736561cdef8bd9ba44e0e48f62863f04f601c21"
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
