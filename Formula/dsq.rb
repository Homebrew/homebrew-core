class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "02c923f9089399bf66809bedcb3fec27022f11829e0ed2ac9c7ff87f72e85d8d"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3de876fc0e597cf95c639f316903d34246e877040d2ecc1a230a27c1820c7b20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bae61f594a37535d749b50a3e3ec25d3cf4a60d252024b22d9b2f0bcfd263953"
    sha256 cellar: :any_skip_relocation, monterey:       "a28f7a443bf4ecfb88347abed3eb4fb70dcb044c08ffc1806de50b61463df226"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4448cd9e5e61ad0b93a8df5bd257941a34016e6a6602054b57b0a5c6a60fc63"
    sha256 cellar: :any_skip_relocation, catalina:       "8515339dbb10d10ec21ae0278a7b5c6fe17519aa67893bc714207058943374a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee039c2ccb717ff65797751eacb931c94ba2e1ecd5dfc758d349dd4e78dabe94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    pkgshare.install "testdata/userdata.json"
  end

  test do
    query = "\"SELECT count(*) as c FROM {} WHERE State = 'Maryland'\""
    output = shell_output("#{bin}/dsq #{pkgshare}/userdata.json #{query}")
    assert_match "[{\"c\":19}]", output
  end
end
