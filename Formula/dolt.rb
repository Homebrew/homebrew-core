class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.16.2.tar.gz"
  sha256 "2475d5fb67f2480a06844d5d4183490bf363f318ee1853e92fa227bf8c465b0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6580857b58610880a7cdd0df554eb0394e6d0320d65f9b2eec001ec42826c6b8" => :catalina
    sha256 "91cc1d012af0299d550ea1531b7c30dec6335a6097678ef77ba84906dffd0e48" => :mojave
    sha256 "46e7a3e6f5d56942578aafd247a18eb8134875c1c7b5cf62ef361f1c08ec56a2" => :high_sierra
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
