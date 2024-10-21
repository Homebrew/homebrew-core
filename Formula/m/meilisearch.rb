class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "c9eefb563678224cd351004de2f9581afb7cd5796b2185a954b6ebc71cbcb895"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f0dcbee94750806890a551a5a1797ecd16167849da8e9dc3578c312991cb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e772220d450f945eb05ad958f3b752fa3e233c1a194bcec06ca739ed4e80b4e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e128d4af809791ff4132e280e9a1e261b466ec2a7dd8cdf125aa45dcb78169ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f81725e712f8f3e20ec105546ae597f499f13d678854fab82c74ff24c20aac17"
    sha256 cellar: :any_skip_relocation, ventura:       "16ce13c174531d3c25c08bf1fc1f4d5fe74a257e6af70251d425dc7417f02235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7891e23aa269da6eaea5bd48e9f15ffefb2d2e244d7e6e5aece758284f3aa4c6"
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
