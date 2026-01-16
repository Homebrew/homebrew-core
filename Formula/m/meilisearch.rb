class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "47e9bfeee98d12351ccc8896b71e5d677b88b4752fb31b2d21f6176268ce5333"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e5fbd6a65f1ddbf3f802fa8f24460a1020d44b9e922ad76fadc21bff499a5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d9f49430ccd33cda7614870ed3dd6d48a0828da9e3d3b0c77d41e63a631f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "519ad97899b696ebd50c10c7ce6425524400e52e3085141f8a1bbcd1277dbc73"
    sha256 cellar: :any_skip_relocation, sonoma:        "e191e262010a1c0e2b3ff6d93d06f751f2e04ebad91716bad996e07ee046f68d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa64fe283d7cdd24ff9a3758dc22f0245d8386bd68c5173f0b74afb87739b751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc704c216e3ba3bb292d8806feadf0fe0b053b7b8fbec4d3e594857eca85fae"
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
