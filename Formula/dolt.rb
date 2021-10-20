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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f4aa113a118fa01de886d88ed68fe994c4cd6b60b89273281df6be2e86e3a09"
    sha256 cellar: :any_skip_relocation, big_sur:       "3462d33f73c46031c0a985256456d068f5c721c6a403da3bc3299417e5ada236"
    sha256 cellar: :any_skip_relocation, catalina:      "d1a176c38212abde8a50ce7d433dd1f92da3b938c1ceba8e72d2683f8cf03fdd"
    sha256 cellar: :any_skip_relocation, mojave:        "e8a9c7f5f67e7feecdfe0df03cf12cab98d5d5c06c23f543bc65eab16609b99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55dc0c88b724814a99c479d3d77b4c8f6ebae6649474e8306ee5de52010e2426"
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
