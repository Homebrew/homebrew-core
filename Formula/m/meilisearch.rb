class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "7d74d8d79ec34bc03a818133358b5ca5b8ad455cc359d18bbab08c65e6b00dbc"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f171f1f818732721af4e0135531efc6814cada2778a09d82fdb304b565e8bc8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29ea4d0814368be3384df35c848762fc055e47a55380c78ad3e528b71aef12f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfde3887bf43fac6a3d84a4b85206af29014fc3790d9cc92eff4f72bb55c7529"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e3e6a06e861abab57f96d42a2a2227a14ac2130ade11166910df734b7cee687"
    sha256 cellar: :any_skip_relocation, ventura:       "f00e3066e067178fc6dccb0c2ecbc7bcb95dfabfc77179e5230e9b092b2faef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "add2d1ae43e11547f4f85062425e4c49f55ef412ac144e4575c875fd5d0e8cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55867964100ae19f324919173f2879717e01e17fa6714f938a665c9f8496db20"
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
