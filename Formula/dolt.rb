class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.28.0.tar.gz"
  sha256 "988fba20f94c639b75e9961179cb5b0444544a89cdd3621ebb4bd3f2ff89419b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be8248859fe5c6b39b390245b6218a8a52db334af4c0de73d70428d8710e2be9"
    sha256 cellar: :any_skip_relocation, big_sur:       "85d77852f7e7e8eaf0b7196055b6d190150d825ebdd7a4623627f0506962f21d"
    sha256 cellar: :any_skip_relocation, catalina:      "fff0e698d4208700deac4bb0c357910d6d03a7418cd2c97dbfdc932cc31aa64f"
    sha256 cellar: :any_skip_relocation, mojave:        "9092ee9345ff274b1641ecae4b4e7542c04e6b5e18e77c3c040c6248285170d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104b037f54a98240acc246573fdae32880003502263dcaea6c59fa797b7d6a55"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
