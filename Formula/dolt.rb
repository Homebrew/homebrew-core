class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.3.tar.gz"
  sha256 "db424e9a3dcc0dd9c7ddfe86b8dbf14862e3cc0595fbc5b2bf125300c3048c1d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7cdd88a2f14c01748a8dea467874d59af2604864582ea067c0aab5eaa1c2263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4a06a87940882894dfb568e3aa5b2499d5a6acd9450890c658828a693cbab51"
    sha256 cellar: :any_skip_relocation, monterey:       "2fda4086f144a7fdc9656e84f8303680bb804091ddf2ec218ab7a0d6798c2f02"
    sha256 cellar: :any_skip_relocation, big_sur:        "59702267e408166dfe0b758a89a041c18024c1b7cde8a0b229484b5f69a17dab"
    sha256 cellar: :any_skip_relocation, catalina:       "6ff88144a441e65e701e19b8b361592648267681886bd8bf91563347cea7aa07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "267a07e311fcf6b19e603eb1570272b9b0c0ed6a12b5e064ca8849a66931ff2e"
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
