class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d6ddb56fd3cf0d7ae2c592f834aced1be4494f21338a79636743c25305a65a00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e6fa480ad6a4930f4acf5d443a7fee16ef72ff4d412e5449dc90ef6082b4e70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6fa480ad6a4930f4acf5d443a7fee16ef72ff4d412e5449dc90ef6082b4e70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e6fa480ad6a4930f4acf5d443a7fee16ef72ff4d412e5449dc90ef6082b4e70"
    sha256 cellar: :any_skip_relocation, ventura:        "bd928d2aa4240cc90c3b433fc5eafe192fd7bad97a97d44e7ca3cfb629aefc89"
    sha256 cellar: :any_skip_relocation, monterey:       "bd928d2aa4240cc90c3b433fc5eafe192fd7bad97a97d44e7ca3cfb629aefc89"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd928d2aa4240cc90c3b433fc5eafe192fd7bad97a97d44e7ca3cfb629aefc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf1571e561296e570c853c2fcdba368b57160eb20b3cdace5bd51a3ae653dd5"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
