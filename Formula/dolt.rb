class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.17.0.tar.gz"
  sha256 "58a8cddff3ff73e5ef922f12a2d0c1a7d7eae62e2d46c4d1753f42c11b67e1be"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f3b4d2046d6b4fd94d907ee3dc543c4fba34cb7d1f168124c463b912cab678d" => :catalina
    sha256 "c65af42645672a8b1278392d61848bc4f2024c518c2cbb9ab29f03999f78634d" => :mojave
    sha256 "daab010ca8778eeb077e8fb5d224b2797456766ab0956b103fdb7c6109a6e4ea" => :high_sierra
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
