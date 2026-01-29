class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "7fd5829846d829dc003b61a0c629ee946390f2015a7c97016265773624048fd8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f300dcf1b6d8e13cee8147970ff30836b1376ce39cd500354de2470d59b55558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df4d042f0cef152a3cfd9f45907ae85160dd8c7d8f2b2fcc519e45c67bf0d937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65df9b95b80fa5bd36fb7aa1127616b0e4b216d703ad00a388aa054c559bca9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cedf6baea7761df588213680ffa5b9cdfba2439d2f4ec6046bb3de8a4063a08d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f7c795f5fe84606d580c59a010973d54170defbd9b18de2278c84cfa5bc1d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133fc1bd9b175c39b8a553ab6f2e86eafcfb34b20e978e9b034f77a0ce0e2982"
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
