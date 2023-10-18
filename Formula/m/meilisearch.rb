class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "79d3b31e259e156b7bb0f3170dec3142100f4aafb8f002222967531751f17f7b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5e183fde8fd13323140fd032b7b72f1667909be0daf273c1bd977cdf5c35681"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be0cb9f3acc349472fa1d9d53c63cb65572fb1356fbe0112becd08db6c21cb76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0df22e93f9971c67f13ee9e3e09a61254cb07160d3f9e16ec099801a5f85a181"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ebb48757aac1e36e775b0b87d59bc63d11dad94adc15b225ab31cf1054266ad"
    sha256 cellar: :any_skip_relocation, ventura:        "65a1dc5aab6d06024ff0b2af0c9fa5dfab244462c87067b5943f833e20f415ba"
    sha256 cellar: :any_skip_relocation, monterey:       "23cb88237d213eff3caa6755bb4dc0c245b71e04539b6d85bf5d858338faafc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b21cdb4ca81c3ba4a0a65e7634be63d16eb5d1e602e4ee5ca7f7d0cb2a63ac"
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
