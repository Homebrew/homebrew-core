class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "99ac928862a020ed2e4b0621dc64d997d3c6ab99b266260bc2caba417c73294f"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99cb6964cd29dad2be2699dfa2526aed3daae0adf50018798e56c934ebd93121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328745cbed7af6b53e32237f705a2d1dd1a44207bdf0577202088d06af3e804a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79673e25cec88b2432f60c4da3632bd73f22d4101c8adec376a2e5a7ce5dc2ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "73fe7dea71d2a4599bee1b6e1639863d909712b37a8c97de50db94972b95aabc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1751a0b71c008d6cb940d5690cbe002bc9cd6f5bf07c58551e618024f8ed89b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f35ca5f99e0b413a275cde1e679a0b483a65f26f1928a3b622d429d8acfbdbd"
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
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
