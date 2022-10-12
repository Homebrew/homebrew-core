class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.3.tar.gz"
  sha256 "5278b1ffe88f6470ee4d51f1256241ee57009a3c00eeb9d6287a410d700d1fe4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5fcbd7d2e7dd6f1c2a731ac10e078a73dd076ca31a5b1b3fd3b32bcfe449660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "372c9b942845b59f0a9fa4eae2053fa593dba920ae39b84ab760742e708bfde0"
    sha256 cellar: :any_skip_relocation, monterey:       "15b1414df3ea438163ca6cf41a0afebcf95df5af8148a05bc861d73fa76bc1f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c0898de1cd3d10c212e7e5b9ff2723465bcff2d1694518b1f949fe24e3c3ce2"
    sha256 cellar: :any_skip_relocation, catalina:       "1d5881384df07c3482ddbbb4219605355cc7b1c63f6ac6468cdc796830f18e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83653ce92d07e1bf13e1f28e0c784f14ee2b38cdc15ae1bacab1d1d41b2dc1ef"
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
