class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.20.tar.gz"
  sha256 "c9d0de5a6a1dda09ec27afc79a4b91878e1ad11ead40b2317710cbfb709b940c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579ae5d491396fdeea08e07811a12aaf0d01bb49868c904161ccc879529d3ec3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ea1dc0041c284652edc2477f9abd0d09d7996118380618b0368dcc77c2b1b2"
    sha256 cellar: :any_skip_relocation, monterey:       "6db826ffe4dde4945e8b33c73c3e0fed1166fa44b73969b34672c61f5b1890c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cae03bbf0a0d57cb12e6bbc744ac2f90e09f8abf9d8668ef607c8fde37fa213f"
    sha256 cellar: :any_skip_relocation, catalina:       "f3da34cfa0251420b9194442bccb7f78893e7bda9a61569c19ccbae115e878a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e700e1d858860bbb481d87edcfef150b162375a8e8a6bed28801c442757e847"
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
