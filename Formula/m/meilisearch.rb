class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "3bee029ad0379efe4658aa3bfa15ea05137e545540384dd0eba99db02ab70cca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9facef77ac39fae8c1c7da27912d6b9fec8d94c6d95fd36f8f7cd3c2f2870ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d717d9d44cf6d6638a113589fcde092248d9bb6665d52768d2722e057c35700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2a25961bab6a0a5c20c9567c8c27bcfaa02414a69715afe92024e468d86a66"
    sha256 cellar: :any_skip_relocation, sonoma:        "e305f36e5eee27a09e03db2c92d245340c8e11998208d330179bc2de6102bbcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498f89c0f96f5a2b35fef14d8cd8f628e03e79d2f5a6d9661f0d199e988ea147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573c023446cec6c6be1bf26f9f571a0e0e2b1d279580da0ffc85d8f7fac1d990"
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
