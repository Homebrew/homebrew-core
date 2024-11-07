class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "c252e00d19223355f132a694dd31088cbf80b6922c935dfc868cd6658aecf6b3"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c8e57c2e8f060837531244811691502bc87c1656499f7b279fe43158d50b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba620b01edf48883fb093b347f1b147ddbc91e3b12b1ed27efd68ac3f5b9fd93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "071c604275d30e27c7bfef0d5f7ebffc8c98833a308a38c035bd75dadda672d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "66bf323f2a573af0bb59ea8c34e6c1373541a47a43ad5f2038c5fda9e4adcf0d"
    sha256 cellar: :any_skip_relocation, ventura:       "9f5b0004afe983da2eb4c544319a84c1bb4eb002b9e29f45072a95c2ecf829ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce6bed09af7dc7f661403400aa9a726bcefea60954fe2a1d213ea3206c357f6"
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
