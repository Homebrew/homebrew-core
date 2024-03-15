class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.4.tar.gz"
  sha256 "2d3e099589f2ba19b0c5f23779294aa897fb39e1bc93627aa28f7ecf9665de1d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7bb39fe6329d3dc75c7e1a98049a893a961f5574caf9bb5a7718da70d6f07e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "157a93e0928f728cec2712e4591962b3819813f39c2e6e4bbcd81549de1e16ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2802a6ca48b909a79f14dc8655b2154500a89585b827127c13796ab51e162abf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f988aeb2beaecb78a87502a3d20e1934ebe3ad6aa532f25dd93c5b9322e1426"
    sha256 cellar: :any_skip_relocation, ventura:        "f2ba00b48003640ecd00024bb4b17a5aa2eb1392dcf2ef8e2def59a7bee5090e"
    sha256 cellar: :any_skip_relocation, monterey:       "e92016001d30473f1324dda42ddc8642a31c9def0da916d007782f64bc13f438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1325df46f348bbbd0b38db7fea5eca0f900956485ac85fda332c461d8f93f113"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
