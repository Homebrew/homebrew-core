class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.16.1.tar.gz"
  sha256 "cfb344ee8947b1cfc88c61928b8bf19bd4f53fb011243bfe65e612068e592a50"

  bottle do
    cellar :any_skip_relocation
    sha256 "b85a08d6e8cfdb8de3be666683ff8b13d7c37d9bbd2a7f9dd4436d4759adcc02" => :catalina
    sha256 "79f89c04f0c54e38818c3925d1d691aa243cf2a2d30bb10eb281f34e5f0f1ac3" => :mojave
    sha256 "5d99fa938405c7d74617a45ba45668069bbfeb189541948eeb823a1455f8a0cc" => :high_sierra
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
