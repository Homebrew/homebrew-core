class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "e09090a947c58806c02c156ed6181c1bed3419af9bdd056cc687493b39eee7f4"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c43e23323d2a358bf8d1834d06c5350be0059dbb5f4c460d3f80e8f639e9109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904eb9ca823d680b2add1852f44764c78a5ac3eb4216a31d8c42dbd4187bcccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f95297eb213a4c0083240b6d4d3ae28af119473697430fec1a4dd46b43674db5"
    sha256 cellar: :any_skip_relocation, sonoma:        "15d6646afb6b520c0d9580ef39c902506a7a54f8e2f6c5c9506b471426da9f90"
    sha256 cellar: :any_skip_relocation, ventura:       "93dedebcc0eedfd92d2e4f73d82a69d9d155da5d96e0788f1302b53e2a9c919e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d0212641a9195aca79a4e8d80de56f6fb1a829630422d7741efe89ecf286b9d"
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
