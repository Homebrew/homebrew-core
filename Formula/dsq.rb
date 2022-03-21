class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.8.1.tar.gz"
  sha256 "d3681fca704c590e6d75787c4839cb045ce7ee30093313165ab4e264d94504a9"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14eb0dd5efec1e57456bbe48b1f5ca145c6ba95980ca7670e10a21bd948f7c40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e318c5f79956ffdbc8dcd05b4e20a92a5be40ba0402592309059852751611cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "628816dbb44bd65e5920aee90eb1025ff15f477724f1e923cead9ffbe4e12e31"
    sha256 cellar: :any_skip_relocation, big_sur:        "b753c486e32470508fb43df898ae1667742e3115bf9fc5203e2ea69a5871d7f9"
    sha256 cellar: :any_skip_relocation, catalina:       "b974ab47174ed7397de6dedd844dcc10d9f1a713d00657ef91795d724a7b8710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf80a1145015768a156a0442fd52cb8549f7b55a60322b29f3ab75658a6f0a7"
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
