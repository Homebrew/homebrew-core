class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.10.0.tar.gz"
  sha256 "a5cd99c32d5ffa63736aa272455a0a5172e1820f9275f053e2de80fcae7a67e1"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f415dbddfa057bbee45a40edb668de9a6fac552a2007136a8f3c1390b479fa51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce57510c7f4dbfbf419d172f75edc0aa7f8af37aa4a848b919f7cd05ae1ffc3a"
    sha256 cellar: :any_skip_relocation, monterey:       "b84c6911ba5feff96401414f0a77f9d1ae35dd86fcd3b42138611611e29d05b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9b3a3b272858ee296e4e080ebaffcfa72106de662d8414b1c5ccacb0a7bc3c"
    sha256 cellar: :any_skip_relocation, catalina:       "aca0a246da1cff85cef053915cf75ff824ee02c24c90b7fd609309a3049e738e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abc32c595c9043d73f574a938285130c3dafcf5a55b59685b2b42d8860120edd"
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
