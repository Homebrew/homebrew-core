class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.16.tar.gz"
  sha256 "a8d7ee585e3991d78decffb91d64bf1dda344858c38149a0cd76764d15b4a787"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0311068b7a23aae3d8d8740154bee4f47017a3498dad24345b84e79da855a203"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2e8377db3f107cdb91df56fb740cca6d5be9e91ae03d17454e309f2f0d313df"
    sha256 cellar: :any_skip_relocation, monterey:       "2bf37ff45119ec6ee2e17e6776504aff7b5de1167428f6ad783c2a426b45d692"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a6b648c598a74215140b2929f6e9a4bcd11c9cb1459447f200a658b32c10660"
    sha256 cellar: :any_skip_relocation, catalina:       "950cf3e059d288f5ffacba84a5085cb01337936bd7ad1196f4d3261dde6b04df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67492c8a408b54c81b9a1176ddc27c9834c4d235c1d537c0f51a9a6bfb73c413"
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
