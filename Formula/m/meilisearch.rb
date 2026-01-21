class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "d4d691a7a3300e41ab1f4abc6b5c80ef779de4e1f4cd1c68c30d229a7fd4cb89"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ff87f768a0d1dbb8356eff14044a41501a3fd7cce05c7dc7df2ee3dfee67669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a448f098422299a430a0a7e6a876579e7c716c2fa849d5f73c40376b891456a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f2131e1264c2d35e9fbf5c7f734192b425473446d6160059ea4b50b1188e320"
    sha256 cellar: :any_skip_relocation, sonoma:        "281c01a662f6b90c7ab1513cba464792b0d119e88d56c5cf0bd2616c7f8926cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2636f677a662c4c0825a92871a803fe5eb322840466a700de805bf797b50adbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d0a2413987d9dd961ca3686d4fd3687bb080b1a044752c24f85218f4b0f7d1"
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
