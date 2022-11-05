class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.14.tar.gz"
  sha256 "b1e21dcf5250ce8fc8ade7baad625b8150dbd4ddeaa2183b65a3898829cde0f4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d7bde2309e604ee6cec3c44dc79dcf2853d45a71caa79983928b9b3ec54fa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c600b5b1900d85ca521fdd454d515118f6bd97e7d2b9f1512993d981a410eec"
    sha256 cellar: :any_skip_relocation, monterey:       "8781419a5c6e37fa27598500b035c9456c6dc867cbb3bab1afb6065cc1807836"
    sha256 cellar: :any_skip_relocation, big_sur:        "b043e45929946ec40fe6f3b7ea28b8c7c43943843eddbea5ee60dee34e133707"
    sha256 cellar: :any_skip_relocation, catalina:       "87db72b95a63b92d8d8cca9c393d85b451be1d14f04995b96e056829df1f6fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf3c3989d32bd850ea39f82b4a89c3827847f31abbd14221338c3480d9696902"
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
