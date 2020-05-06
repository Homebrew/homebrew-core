class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.16.4.tar.gz"
  sha256 "41247460a7d1b28c17e1706a5215ba6ca58984c0741c2efdf8d369cd2c768b28"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a9926295e24c880305d02126b52aebaaf6515361c3f403a59fe2ff37fc89f4b" => :catalina
    sha256 "ef452031e1619fbc86910ed5babc435aa4e11cade89d48de1de480d448240bca" => :mojave
    sha256 "145293ac225f936b282da83c510c6028b2f61ad40b40a3c6b4ab5f536ca8e618" => :high_sierra
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
