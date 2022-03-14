class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.26.0.tar.gz"
  sha256 "4ca2b4e746c640fc484a757e79503a7029aacce2875a57686bff89d4c76873d3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d490db1d3bb63ca88e7bce1696495031ac7a01b0e121c27083f65a8d2e59078c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e37108f4ea93fd81e4e58ae787461c94925c9cb58ea77b15bdbd896adffb81b7"
    sha256 cellar: :any_skip_relocation, monterey:       "fc08d0b3dd882c2523ae37adb576b30ab7352ec2da253510c6005a7656e7404a"
    sha256 cellar: :any_skip_relocation, big_sur:        "31096be094eafab9a826b183e6ad689a32a27a6fd852a517388e1db8028b0662"
    sha256 cellar: :any_skip_relocation, catalina:       "b8bad04595bc4a1f49bceb2d6dab13d1b5c0578d0bb7d4fcefa54cc9c7b424e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e5d4ec480980ff654e665ab607c2e0a4e229a6999201a429fb340f54bf2f30"
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
