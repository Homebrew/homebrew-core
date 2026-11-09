class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.56.2.tar.gz"
  sha256 "32d48222a896dcf78c3b3c55f6182742dc50a0f8d47d102544be5ec48b8c882d"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d293230d26f36f36a1bc9ff9b6e8b8161b4e0733a3c52683738f544e754d96c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed4f2e6e8b4f167d2c14b91d4dd9eaf3bb16d71d8c9226d5adee58cfacbf5a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c6574982e8f38c267fcd04b881106340e0a38f7b85f87a755e349adc74e07f6"
    sha256 cellar: :any,                 arm64_linux:       "b4495dfe246057d869d9b514a51ee4508f5c23a827b485b7efe7a1c1208c4ed0"
    sha256 cellar: :any,                 x86_64_linux:      "59be6c203030d08af554cc8634bf9b39dcd1386c2427f3df03709217c467c62e"
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
