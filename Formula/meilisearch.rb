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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "511de1bff75ee57a09a988883da9d7e8f7bc6ffb64beccd10e468ca43017c17f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65b803f08726a534845cefbe91bc76471939870596639a32f501b5593d936a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b59302ac45610eb6f4e12991ed1552921b259a7d6ee8e9cc4b6af08fc673259f"
    sha256 cellar: :any_skip_relocation, ventura:        "cb3cdacca43facc5d7d2c41e45b90358e6ff161dcdcc528a94284a44e6da3d37"
    sha256 cellar: :any_skip_relocation, monterey:       "6445745a24497738aae296cf8b63ac72a748ef7490ee0d71afd948abc5bc2bbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bdb934397baf99ac816e3b33563894aab85b89e9c2b7764905757061d338843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efc60d6e50c4ccd361a925b89f5b019f381263648d915a6932b96e4ab95cfd2"
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
