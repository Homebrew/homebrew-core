class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "b03b36b970cfce6a69f7b978a10263369f819af8120758a7dffd9320621c8cf2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c27461b2b35b8fb2d35c78d5a84beee9f3307f3488d164450dd3b615775de9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c1a708caad19c81dc06562b390b0dea3371162b83a815d992897e2e2caec1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0fda730e8cfa95d52e3205efd5f9ff69610dbc250703edc075aad538ff495c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4eadd271e0691220aea788a05640b4f47f2eb7daf1b72e82f12bcd70fd94ced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339e0940b1979d38a4c7f78826b95ff78b40b2c30b6b8626393aac9479d05a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bcf4737a83e61d304b73fce1afb0cebf124c2dab26499a29a46017522f7086b"
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
