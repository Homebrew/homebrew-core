class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "088fd72985bca4d4dd3de9b1498397c59d7927dc6b5c82286acf9540cb4a0c1a"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "705119db3528e718319f083c97ebf3c29f45f57b0fcf549e838e4aea0b1ed056"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d495aedc81d19758e914f4efc1a29c1ada33be030a24faaa0a324f574d1c8b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23d54ed506fddad1dae2dc4944caa8071331c5c12194b134dcf1801e16c7d2b8"
    sha256 cellar: :any,                 arm64_linux:       "dde0f4246da3585b93055db6068e54465069ef0798f38c876079ffc957fbb773"
    sha256 cellar: :any,                 x86_64_linux:      "725af9df40c342c612783cf83612a869042a3dcb8b0396e4a57806b0c2f883e8"
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
