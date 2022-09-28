class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.6.tar.gz"
  sha256 "ab59c66c3715b77cfab80d970bede8a906d3e3bed12f3d301ed4072a5d60430b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fd9ef7ab0bb6b70f8c30b99670efb74cecc18f066a218aa0f2811de6ae24ec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8224c5a5ec6986d02c85673ce30986f345ab3c8dfe161f9d68dde46fce2671db"
    sha256 cellar: :any_skip_relocation, monterey:       "abd1654387867e31348da11f4f942fce059b46a537529e688932b83de1619c98"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5909c788d25c8496c6fbeddb8343fd8e731bcca685b7f3d402ab1ebd3aec54"
    sha256 cellar: :any_skip_relocation, catalina:       "28199e79bfa1898451c39a92faf4ff16504abea2c2a391ad009e43928983d0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c242c2433bafc1bd47477ed67f3f6c62d068f2816983c62c935c587ccd3158d"
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
