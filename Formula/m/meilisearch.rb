class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "5a826da5f19294cefe2a5f8f0b4282fd4252f62fd2509950c42f57a6d178fcac"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5622a98097a93ad6798700509dff00a2b79bb228fa9ff8441a9d73fcf31f84e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed0f6bb4c973d0569c7ca5c7dcc665b85f41db195a0c2425eeda61a79818df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d256399ec09c88ad41f3be0fabd650690dc5b3275a3bfb366c244c9871ab2293"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbc259a9a5d347ae0568b9428adf9cf1ed1eda1e8b97aa87df7dc27e83756d15"
    sha256 cellar: :any,                 arm64_linux:   "bb6281c9a7fbd251360522ebc73fca2bb14c2c54461b37af3ccaab685a0872bd"
    sha256 cellar: :any,                 x86_64_linux:  "5641895fc44605776a967921455f0b495a84bbe387496aaee8e8cc2f06914705"
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
