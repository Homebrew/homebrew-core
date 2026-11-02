class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "6af283d7205b9e8028cfb9a1552a28ac70d0a58e99f7312566652c7449c46b77"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6002a6948046c9051da3bfec7b9191451e8928b76450bcd370c835b9b163a67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9e2aed6ade8661c7c8aa91361e98c38663136eeda0f25298d4b540cc00d55df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "063f7472b3805621892247c20b70e1f8ec2489fcfda984498e22864664fa1ea3"
    sha256 cellar: :any,                 arm64_linux:       "d9caa304ea60ac848b611c6af7b6647acbe6d59da59e973067dcd2f4076aa5c1"
    sha256 cellar: :any,                 x86_64_linux:      "39af4dd173bb027e99629302c8cc1eeb633e6b5fa053d7a4eb32fc3f2abf0b64"
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
