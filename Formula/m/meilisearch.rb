class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "7f914fd3dba8e6a9031013370e21a75fc9fb3cc991169ac49f62b22260c1f32c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d92b952304ac2aa521fa80eea19bf7fae33a0dcb35b1a92ea56a9e1705719bd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1377fbc0bf5ca463048cff73e96ab13b29953d3d3579c3754a289f653a674ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ead56e961d3ec3982ac93eb9b4031ebca1b771fde8eda9ed088a337edac1683b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c38f799999ea9db6d810907c59e0696c5610d56f4fa83326d7308a937ca860e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18cc190f401cf4eaea6ad331defbed6ed169c52e851c269547f8bc7c455c456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbed3727d9a25e3f942c2c84c1b88e605c947ddced17eaf913b890e5a0eb8335"
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
