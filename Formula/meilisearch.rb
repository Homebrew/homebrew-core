class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.28.1.tar.gz"
  sha256 "1854d219df7829c3b1de107f63f4f3a125954dcaf13a71b36630cd996d286177"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8af185e25c59284fff7aa9549840ecad965f7241206d623b56d3a62d456e06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c5cbd3ce67e3907d4cb7724c345dc27ff74fb94150f0be008dccecb899a7791"
    sha256 cellar: :any_skip_relocation, monterey:       "229aacefde192a1e5bcbc5336fcb339f2d650642f7660a0802fc3f944c023fa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "12aafaeea2a141b79f420e04d3d38d88482975d6e6afda269dd6e35178d90081"
    sha256 cellar: :any_skip_relocation, catalina:       "e3a40500b9c33e34951e29d302a7894051f905c1efdf647399b73e0c3f0a5b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a955dc9a4e1894c4e5bdac8caa1d1f065523e60d5c7ffb33fc6c809609835d"
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
