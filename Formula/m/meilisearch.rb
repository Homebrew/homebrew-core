class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "513b736ebbcdbba42ae71758f7511a6079e3abd8e3c2bb379593f5fe00b099c7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32b5e0fb304f6e375a81de8ac792c69bbd5815c68b0daeb4f3a47a0b1595036a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eedf415de46c34d03ab2195d7ccb20b173cdda6d683ed841c8bcd89ca71efa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7cbf9009fff4b7da1a72a372a6440a0c0ed3dd8933990ffe7ff9935df68fe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "998d3153d12698422105d9f931196d4fbc30c0e68616f4496880a7fc631dda0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "872b676f4ceb96e470d64922b41f047310130a4162d01acc1c8d16b2a693e0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6e0fc60b3d4f6223134904a1f91c1c16b67426c48f963b7c72ec6bb3be5d19"
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
