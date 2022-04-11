class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.13.0.tar.gz"
  sha256 "d0a5dda46ae82f41d57b4e0a6384a1038c9bf58c430524c4b0df1c397e0c341f"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee20afb4700afd6bbf55e2051b89c47961d1cf7d19d6948745cb445bb6947d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1385958e57b9b40483702978cfc4c33560742c860f3ceccac5822c0b46abfe26"
    sha256 cellar: :any_skip_relocation, monterey:       "778eb3151965569a5984d821861a493280e44df6b650a62d6c0aa13c17d38544"
    sha256 cellar: :any_skip_relocation, big_sur:        "15e7700f225dc64c653b6fa47e37848a468ffc8bb13e1145f86109d6e1bbf83f"
    sha256 cellar: :any_skip_relocation, catalina:       "bf1022c51e25c3caaa0b6101cf28ee8d2c6e7b3e968d2aa7b1d24dc93a9d577e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14ed81d1384d9368313cb8d1963842b188580853d52b9f98c5be78b6f4e0de1f"
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
