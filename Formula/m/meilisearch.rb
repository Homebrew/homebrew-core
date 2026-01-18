class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.32.2.tar.gz"
  sha256 "80bdf8841ca7ae6010ab608b849dfa56a77b3087e509921c3cb5c1b95372bf95"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3091c50afe63c74ca0c54bf5a88a5059a8ebd0a3921acc16ef431682bedf689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226b1970abc73b85e03c771f027b029812c210ad5a43151c47f1894640075be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c40ca4995c4a3a287e2701923652c036d3977118f7efa72d66648d435be5ff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "300a209369c86abe0bd701e3fe8812c4b9c8ece57470a768e7033d3b36dd0b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d4eeb7f681428c58ff06b96b45381fcdd92a6a70ac1c3e313992c85098fdc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2faad959c8c0b7df147af66cf1cb7d1f8eb772f4a53ea47af82fcfb9641f4945"
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
