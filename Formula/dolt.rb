class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.18.0.tar.gz"
  sha256 "326426242a4e6dc7ec372c701e2e90f506f85dc33fa876ee5c4337b2f851d08a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1f84df8d5cd51b061724199873383b33989ca1b679355714f3aac0b55f5fc27" => :catalina
    sha256 "1ebc1e38546ca88f0a1adaa1fdf46279879a183c11b818ea07f6c803d70e5568" => :mojave
    sha256 "384b837994c5bfad9112a131c54a90c1b147798701cc4adee0b29c1f2e6bb626" => :high_sierra
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
