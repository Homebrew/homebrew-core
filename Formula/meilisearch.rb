class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.30.3.tar.gz"
  sha256 "58bfa6b4b603d23fba00ae93d94a5f3e0dfb18b4d17dd6997d33252e8924753d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f86ef0fa5ef0d880e1e6ad905a1668545ab65af46b5b670f0ab6a75cbb02c7a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed553db19ea2e1a6ea33bc8b30b21ca2d9127749e38e7782cced8a17b50f9a04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f784430d6f2a98745f2ae9edec625b0443822caffe4ee32beb03c5c568cd2669"
    sha256 cellar: :any_skip_relocation, ventura:        "051825eb3259d66200231e56bcdd7d9fa0b8daa1b8d02e6c8bf79d96ed4a8f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "536b1ff059c193ec8cbfe8cc44589714be0929c73694826f8a2cde9eacd7a9b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e41ecf47b952ccc3fe611eacde221b2ebb238fd3df7cd30a0e9dfc9d69a9857e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6095d9fb8ae99e2dd3befdcb1bf242911f6041968a25531b81620fff5e49a231"
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
