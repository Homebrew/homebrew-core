class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.1.0.tar.gz"
  sha256 "793e69d8c8fb8807326d3e1cfbb0d63babe8f74abc33f62e6f7855d03d6faeff"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae5695f5b3e385f247cc534161a7fffb97960f37509baa487679e20c45488185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef8eabd3f8acb4a4b187e8b6285bf6b0c41cbcccb5741627126be79f3621ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "321f2ff78b55f5979e66a2a189b95249687157fac025d12b2eff0bc82d574496"
    sha256 cellar: :any_skip_relocation, ventura:        "d376b0868f4c8341acba959615a25144b29372347c5214bf4d99919894df863d"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e3232feb1b99aa269f320aa4619751ea49d1c48d1b579f0f2a0560b6b7266e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0591d0fbb7455be2c0c8172401259d37074427b08b080c00a97dab8d5c2aa6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e614b27d2e2d9fc3cc3a2edb140e918dd302a14e252cb20b458cc7d224af8db"
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
