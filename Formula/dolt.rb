class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.19.tar.gz"
  sha256 "a6036334f2e8854b253a1115aff2887f1574cd219b51abd81eee08827164d56c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9168f8cd7abe31401737762e978e98c26bfa81c6b10faf4fa5486f9d0a61e645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42475c4346f5c6fda620ee9e67fa826a99d939a7e780a2919ee7d340b5547c95"
    sha256 cellar: :any_skip_relocation, monterey:       "64898fd1bebc96a00abbc9a1c06ce96b5fb270a368424b78f3d599d58271747e"
    sha256 cellar: :any_skip_relocation, big_sur:        "86943b1c9f0851840af06dfa611e62789b7984a178c6b9f054b74a1361417968"
    sha256 cellar: :any_skip_relocation, catalina:       "894be5be11f2ad7db35a93287bf60090b6f2f8917db73bfc8032cc829857c9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f3a4645d8c3fe470b39fd6a36aec91a28e4bc2cc2d8db3de4c9e4c547767da"
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
