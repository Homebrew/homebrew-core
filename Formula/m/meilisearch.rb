class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "7eae4ddee32820cd1a4c9dc3ef40f5326c39608be13bde5374accf739026f59b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3a908fcd2dd0d1dd4862e00a21cdfede2a754035630fab43a20ab242ea986c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d1fad41f09fca12521647cdddff23a5636488c61d5d5deb43e3c05449b341cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0190ef5781dbcfa6d710505ca34f40df0e09ca54901699a83e9b2f9a27912f61"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1d4e312b383bf8500d924f20441d01003310c2a7cfb6bebaaca762529a0c6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b7f20ee284dc9ab31c8bd59339927bfd1e2c6166f81c15dbe6bcebc3cd75773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d1dbd1ae91b0816dfb731f14d6dc586a9034cda2b93339900325e594358b69"
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
