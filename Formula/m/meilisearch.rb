class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "6af283d7205b9e8028cfb9a1552a28ac70d0a58e99f7312566652c7449c46b77"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ae7f101a92d68abd76efa36139f7f351f64d79871cc723cba0b5a22523f1010"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2906262206701f6570d336750512cab5c550922b161839cc35996d48dc0f8ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbfc05782d5e0f4a3fc8d91f07a92753d51683b9d6a20d6de7b4d8bd8a28044c"
    sha256 cellar: :any,                 arm64_linux:       "cc09a450768bfb78f26235beac7fc24bd20501b78bb2787d35800cb122139816"
    sha256 cellar: :any,                 x86_64_linux:      "da4754164dfad1ef05af20b65a3b337c08eb5cd7949cb762d5334d1966f1e151"
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
