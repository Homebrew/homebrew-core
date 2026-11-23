class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "e4e6f58d11296d36c8910535ca1cd7b2730bdd2d3f0715ad33996791ddb1a46a"
  license "MIT"
  head "https://github.com/meilisearch/meilisearch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "dbe1b1381cd1f4bcb2872e31224588fb271a1b8d283eb932f1e08dbe42e20dd2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66751752bc8989f535af1a80fb731445bfb1ea3df8612298a57184a64688fea4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ff400de127d459f0e5ad2c629e433e0dc4978ab3599cadc17836f1b98febc76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8aac4db9ffab96016effb90c72113f4084ed5296ec3a2f78ed1d37c2b59ace17"
    sha256 cellar: :any,                 arm64_linux:       "5d77fc02405722cae6df161e0d6267ce8bf233e4ed82c9f9320613a232c655de"
    sha256 cellar: :any,                 x86_64_linux:      "c45266bcd59dea08fee727421067c66c1d0fbdd1bd64f94ea46c65fb9ef4e020"
  end

  depends_on "rust" => :build

  # `:build` phase needs network access because of `lindera-ko-dic` crate
  deny_network_access! :postinstall

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
