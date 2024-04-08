class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "c92fa6c00a1cc57fdf19fc861f4a341e5a99953f2e8df11c4e6026c80351b7e2"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "888c9310eb33af1962c52add453ddae041881198b9c601ad5c54b795f2aaa720"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01fb304dec8a83c3655964927ca92de4fc2262e1f3fb8a10ad8eb85c76c55ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afe1110b6190ff3de2b0251177d8cb2b04aaa8db017fc9bee7619c11f80548ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "632dea75e2995e5c61f49e36426aa91fdb999ca9a9eec5a3fe20aab3593929ef"
    sha256 cellar: :any_skip_relocation, ventura:        "ef1c1ac777cc10089de0427af49909667c3cc6cf3ac2abb9211899c22652aead"
    sha256 cellar: :any_skip_relocation, monterey:       "c918556b41eb57a1e1e933af109c40d704c11fb64d81c399eedddd3139587c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db0f1d0cc8cb940361f7fc5153692ff4ff795fff3b0c30c3d07f8278bdd4f86"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
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
