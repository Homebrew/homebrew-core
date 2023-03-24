class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.7.tar.gz"
  sha256 "349b20f34f8a354fd23aa58743f5d9db6000be3b203d6c7d93640becf3d67f39"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a2acc7e6fd9e0623cfddedeccaa266a48d9cb9bdbc1b36c4aa458ceb7287809"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2acc7e6fd9e0623cfddedeccaa266a48d9cb9bdbc1b36c4aa458ceb7287809"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a2acc7e6fd9e0623cfddedeccaa266a48d9cb9bdbc1b36c4aa458ceb7287809"
    sha256 cellar: :any_skip_relocation, ventura:        "ade5257137a57adcf1e7591c19cb5784f5d84317dede711e6be10ca96ab44f19"
    sha256 cellar: :any_skip_relocation, monterey:       "ade5257137a57adcf1e7591c19cb5784f5d84317dede711e6be10ca96ab44f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade5257137a57adcf1e7591c19cb5784f5d84317dede711e6be10ca96ab44f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fb25687b6f3494e1b1138e506fbdcb4042801d84f8a0159002ea6a52f1c5d2"
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
