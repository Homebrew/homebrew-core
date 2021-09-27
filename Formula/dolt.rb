class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.30.0.tar.gz"
  sha256 "3b1286a6a2621e3b609386422fc154bd8daa3bd40fedcf4a53d0c6de2557e2d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bc8c539c3e8585cebd33c5f90a42e5a292aa57ca15bcb2d09d094f91ba9e414"
    sha256 cellar: :any_skip_relocation, big_sur:       "95e62244f8f7d1173b053a5207842417d44e6c7b04a72d6f9516a338161a7311"
    sha256 cellar: :any_skip_relocation, catalina:      "68e0ec46f4b154a7d5969e297dd606823d9ef9b6c95a2abe74fdbe1202f9932e"
    sha256 cellar: :any_skip_relocation, mojave:        "2790ad6c05ad9dcb2cfa54d215880395beb3a5e35c11350df3493d44ba9f65e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f064d3c029e7fa5c789059da78b3e57ebab9313fa078543854f17ae01406825"
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
