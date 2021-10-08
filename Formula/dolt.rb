class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.30.3.tar.gz"
  sha256 "e41b41deae32816f955e3560246977773ba0e4c8453161d084fc7193a6915359"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "934c960a8e71239236c53eda301c9dbe2821fc0268a3e424883e4016cb339f66"
    sha256 cellar: :any_skip_relocation, big_sur:       "78c1aba07f3333b1d99d3cc56e4496e454c1d0e019de1b792c4828ce03bc7bc7"
    sha256 cellar: :any_skip_relocation, catalina:      "e73f94a672ff05b0d09ae7b3d19cf7927c001b06c4de6f8ad94349bc061725df"
    sha256 cellar: :any_skip_relocation, mojave:        "fa5ce95a4fe79ffb4151266ccb0c11c298b9415d262d4f17a85d37166ad1591b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5311218482503f06164c18df07a6d15b11a0eb1cfe2937f4a2da190f93f340ba"
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
