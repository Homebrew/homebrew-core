class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.48.2.tar.gz"
  sha256 "284eb45dee447d844be33f3fbb29d1654729b75fe797f41a9308258230d21846"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a9d3722d50d3ef7cda9d532bb5ead280f25892bdfef389f2eb45f7e38a9431f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba8a30ebfb5e63e8dddefed392d1a39cc90378b9865cbaf9ef19b00fdbdd468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f6b7a8ae9bc46a94cfb9954c6d2697d221f63ed687194a80b9e9550e467ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce08962c99ec7c622d32bc0f6002b516f4dcf422c7c3376a99fabf0131b3ca7"
    sha256 cellar: :any,                 arm64_linux:   "e1f8ac3e67c368f22d9d139d9e49c7f30cf3b8566951ededd44e1a31e25e9d8c"
    sha256 cellar: :any,                 x86_64_linux:  "339faf7be58cc433f948f5c041a22e86aa23fbcbf04e78f6a4c5b321239fd849"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
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
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
