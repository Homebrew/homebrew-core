class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.30.1.tar.gz"
  sha256 "382de9c3fca52ded29aa569bb67bc6f7a36fb65bef7c4b4916bd10e73e2ff3fc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcc57a4763b60c3069646e3f772a1c98b2068391b92f1b3eab1499ef74516307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082d964c9ee1704271425c4537eff0199eacbe74ea54f8971ea0d76906771926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db1035bf573ef99dbfa4fd6392a196471541908fc928c7e91dd6522f30eaa683"
    sha256 cellar: :any_skip_relocation, monterey:       "642f8f4e1a89a37e646db3de1a73aa73afb47967f098b67840dad454560b6ad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "67cb5cac0cc76249eca0909dded81fd1582625470d636949ef2beda1825131c4"
    sha256 cellar: :any_skip_relocation, catalina:       "6dc671243cc0cea4243e80933068518602dd3bf9d5dbd58cb0a429ad9c1d8503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42679eeba0cf62010edbc24a3d8c5108fc14c457109d3534345a5388cd447b02"
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
