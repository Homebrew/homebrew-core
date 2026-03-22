class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "2feb7e03d2b0b5f4b92c81d94e179b8382b0db1278630e576146514c32430c21"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "981e4c8f29e35236b02328145e5a6169a905a65ece3ae2c6d7acab57f9ab8857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d58c79b73285ad4ff0647b2491eb379bb385bbfeab3cee20dbe3c53d6a45276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd5768ffbfb1ebddf0e967f59faac6fc6e967f80d32ed82ff6014bee925b6e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f77c6d4ec0f8a401ed66c07b7af7d184d73d37ca6d98e3d2e99873fb366d537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37821842e6f8d3239371123573cd81358e3eb6cb4c7756680c264d397c51cdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4553774259d11511847af916fef199bf4997355ce44dac8fc7f617c68429a203"
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
