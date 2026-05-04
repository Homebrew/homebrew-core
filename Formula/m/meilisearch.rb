class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "041440d734931014c43243d10bbc42861b54b7603565c663746b73fb419ed124"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "867130952796de2c989e3ba39680a2b790fc512943c436fb39ec4794afe785f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c879ce069a6bde4375ee0fa278480b3c1ab1da41909a6fa6cb45c984491abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7364b43205945ce668570766ef6521b0eae4f4b97c1cc64d0775ddb4e6256201"
    sha256 cellar: :any_skip_relocation, sonoma:        "38783e99bac5bcdf4c9a852e086badb0196d3f394745717370f84f7583034161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14570f5a499ce36b6045bd351678e0acfe9f692c1e66fb54e6694d4c66b68307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0274affbe7d171639f5731cef135a5c3c382afed85d345aa932e4b75a01db0"
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
