class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.7.tar.gz"
  sha256 "d3c24c25e12edca3515a7e3da21eb61cb0d48be389bf696b9e47639ccbc2a9bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b97f8eb82faf6d1fff72628f5c9c85db8096f1d7fdd4b78168852e196e591711"
    sha256 cellar: :any_skip_relocation, big_sur:       "29e97aaf733ad2518d9a04204c6bcfa1972c43ac4b5739e99fad2ddb34a50f67"
    sha256 cellar: :any_skip_relocation, catalina:      "6f2994843d5fb27ede4f087ef40545716b35f97f7125dd6836d0e43a6bc0b299"
    sha256 cellar: :any_skip_relocation, mojave:        "786971851b2f6be705433277b8e811e5cb2a3b25a1fabda5e25ed902a5f29297"
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
