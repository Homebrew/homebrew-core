class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.5.tar.gz"
  sha256 "0efd0f6358560146fac059db97a091ef28f01b1a8ab6bd0304af05ed045355b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642bf9131afa6065b52d84be9d7d3d898e285ae4f5b99b1f4431cc3a2a75919b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5306a6171f0696c80935ca975cf73a8d45dee20b46ef89803ae0dd547d51fb42"
    sha256 cellar: :any_skip_relocation, monterey:       "5c2211c565a8f982b5e7c023faf79ab2b60c7a53efaf84f4d569d64a612b1454"
    sha256 cellar: :any_skip_relocation, big_sur:        "936caab52f3109216ab2ac3790dcd5d46c19d46d87a9e1b8c1d113d715937624"
    sha256 cellar: :any_skip_relocation, catalina:       "553dbb84278fb609f6ab34856967e54ce83431990dc688ba26840bef83540819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fabb67eebb708fa78ff48040e3dce0c5ba014d226e7c8f01d62cdd9da7ecf1a9"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
