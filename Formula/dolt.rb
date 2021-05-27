class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.6.tar.gz"
  sha256 "6c1539d8b8673940b0cee6a616b8116d222198bbed26cd9c79e786b954604b78"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1895fa8e87d04afcadc295a8e1eeadc8f2f326cdef2c0821f3f8a2e5502c7207"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf81018a3ca12b88b3328247970dbb1c2d3c230e76e21881541b7da51ccb99cc"
    sha256 cellar: :any_skip_relocation, catalina:      "9f80c8ccb6a2def910c1a27a50ce1ba87859d806666cfa42b3a584981b920031"
    sha256 cellar: :any_skip_relocation, mojave:        "58e6bcd47b3607f23522ebf451af757b468f89cd3a1d23dfc4e4f1f81fcd6e4f"
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
