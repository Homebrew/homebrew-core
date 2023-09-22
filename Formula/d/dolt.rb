class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "46db184117976727de81818b769b2d52258671cd46b78b93a2a6cced386b4071"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4543a677e467e627c484fbdf81655d5ae068a64374eef8f7957c28ad326a320"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8a5b03adf07070536b88561b5cb6eb691e26722d9f5355b98f22b745b48c35d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4da079b691415271631c94ed876f888678d845c76b04279e6093e51b0bfd6257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ff88e1f2264319c4106e980dbb4a05664500f5ab311939d33ad7f478a013ab9"
    sha256 cellar: :any_skip_relocation, sonoma:         "60b5130d97c6068d52a20639b06db9f952d82f48d7b6539982adbca8797cd6fb"
    sha256 cellar: :any_skip_relocation, ventura:        "626392b1912bce6ee023e90311d9255d6d52f4db807a987eb1dcb5203d25fff3"
    sha256 cellar: :any_skip_relocation, monterey:       "b463e1481e7a3b1bafc6747917593f083b4a340dfd534d958c7cff75db249f15"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e668b9d894e4f5904cda556bdd04ed0004cd97a8de305fb2bfb0ef30b934170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5154070ffe40987cfbcd38837da358e4ff52bb23a6f572638abc18e4fd961f97"
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
