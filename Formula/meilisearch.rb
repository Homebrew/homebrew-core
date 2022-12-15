class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.30.4.tar.gz"
  sha256 "e5525bf86e863e2228b8ab88ae10a896baa7fb7c0c1ff38c428048ad3035dbe0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f56004536227bb2040373ef13560bbfe847c56edf96365ac79e7721aae3808ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ff327f296ceab5249dbe80d4b464ee7e15adb8d405d18f1bc38e493c75d9e56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26dd64abfb613525a5b71f62190cdf0a598ffad60e0cbf4ff8d62f8c51d93e1c"
    sha256 cellar: :any_skip_relocation, ventura:        "d5d70f710308160aea80a5de438ed267a20d08236f4ffca8446f30b3dbb7500c"
    sha256 cellar: :any_skip_relocation, monterey:       "b078fd2972d8d0e44016db9cf250cca395ae379716592c86a22e44c1fe73712e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c25055d2911364bba7148dce587847d1be5fae0c6badd3b2423c351f597d858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c96a7d3c242b72a6dc39e33185d60e94d81866a2512714693701eac153025c34"
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
