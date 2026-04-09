class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "f95d99f992f180452a5e28c3f2c19f441a3fe96d1f92e592164f97a222dc69d5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a94c8dbef09fff58b3e81330bdf0d634b77f6e46eae72516e8b168b354fe5ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c27108f1ade2850d5da4304ed6c352dd016d0c7e21a6b7fc289d157c1406f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b188571251fb292826db5443dd16ed71506d5f5df6576c50c0773e82885228a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e11723ded38fc7890638c19b16f11f6a50880ce811d7fcc17dc70ef83252714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd57d96eac40a6424797f78e089884006ea954c7969aea62224a9a9f2d2e1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b13da4b4c4eeb840cbfac954a6af46a47a38abd9863bfe8db91ddf78c079efa"
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
