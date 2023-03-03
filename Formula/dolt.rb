class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.54.2.tar.gz"
  sha256 "e53022e95b21533b2a0e3dcf9f2f938b0392dc405fcab792ca8c754d06a66188"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4319ccb6bab3987e2136eb091d905a7ab7339e08ab3f92834dc074bae327761a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4319ccb6bab3987e2136eb091d905a7ab7339e08ab3f92834dc074bae327761a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4319ccb6bab3987e2136eb091d905a7ab7339e08ab3f92834dc074bae327761a"
    sha256 cellar: :any_skip_relocation, ventura:        "f1b1b8a351e81fb5a3dae1c7b27911e22ffbfd590c6b2917c8718f2c76a3b5a3"
    sha256 cellar: :any_skip_relocation, monterey:       "f1b1b8a351e81fb5a3dae1c7b27911e22ffbfd590c6b2917c8718f2c76a3b5a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1b1b8a351e81fb5a3dae1c7b27911e22ffbfd590c6b2917c8718f2c76a3b5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0d7bdd80bf41655847d90aa4b3206148747a27f689b12b5330949135191095"
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
