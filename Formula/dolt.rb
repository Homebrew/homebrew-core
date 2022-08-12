class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.25.tar.gz"
  sha256 "7df847d03cd97764995107b89f3e4aa19cb500c207dd48039af292e09169d572"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7fb92a6c2a5a556c80fb39db8e7157b4cde9382355aa08648089bee1fa67785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "464c57f85450cf46a2879be8ee676439cdc81b31964edf908803cc4f94679083"
    sha256 cellar: :any_skip_relocation, monterey:       "21253262227e3f0c1593ca4339a2c3d5be882bdcea3be07ac6cd1f5499c58dc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ec6783b129e3aefe000a9bef883c7253106e10a998fa6052612825d19c51c9"
    sha256 cellar: :any_skip_relocation, catalina:       "ef35e85570cf412d812202c3f15eed7679817023011fecdbb786e4c475bebfb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a69e19a90957bce0c15a75a1f30d8bf6661e4eac4def10db9447cdb1af14987"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
