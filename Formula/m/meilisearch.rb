class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "efe82a64d647e4959729306c3cee50c0b08f3bcbd72785c67cd55ea189fbd0ad"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f49561af7c6b98dbc03a0e481f6cc0ee15e8c2f5d064dc843abb33aad32f1c59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73758f5770ea575252339eb363d6984cc6d540d09937c6d2855f4c8d005f4a99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d62c6bcaade69e855589ac9239eaa36d17e58e6b8cf925a532b23c722a21521"
    sha256 cellar: :any,                 arm64_linux:       "7e173a9523fda9bb588429f5828c6f7c94cfea73a471df047da4e4c7ffa9c81b"
    sha256 cellar: :any,                 x86_64_linux:      "9018c4ee6b7f6c38cced0b87295f2f0bb63bfd325b44138e19bf41114e81cb05"
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
