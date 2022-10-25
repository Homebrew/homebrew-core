class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.8.tar.gz"
  sha256 "d4c7fb45ade98bf4277be286a04d8b7be0d50ac4165b821e04e1e96e16ce7871"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c1f5f9e2cf414b8df28db6f6c1477c37014a2ab15176a39dac13f006d9b536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d284d784de47107dc8f2db014a97549fbea0c99443de47a461510836da553b03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5ff4937d1bb1450213b9f8dea7151399dca5b12d2bf4d3370ce0a6ea3684a1e"
    sha256 cellar: :any_skip_relocation, monterey:       "3dcea12ee62a7c2b103b32881570cadaff6c66b245ff31326749fd67a0cc68c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac98c551a5a9256a7d67684be5b84be68a3b8e7f9336e62db76862bacde1012"
    sha256 cellar: :any_skip_relocation, catalina:       "2294336be68b44ada5e66443a486a0dac6ee3678a1f1283b947d7a15fd141084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7552a9ba3e3c8d6109dc1152b3fdb7bb148faa8e0ef6f082778fdaf9e7d43f3a"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
