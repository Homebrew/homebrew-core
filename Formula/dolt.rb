class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.2.tar.gz"
  sha256 "31e714eff1daff2710924144163a1382dd0799b098fd203689ea75210e41433d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad53294325cd7c687ed8a4fa562fabe2a5b9b355a5ce21c17e6c40a9e4606e8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d73aafe1e713d07c6b02e05ca0a6afacb65e088910fe110cbbdbf6f687c44a6"
    sha256 cellar: :any_skip_relocation, monterey:       "263b180c4999961d36aa03cebfa2c0f91239c6b37a5ba810d893866993e857a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "663fbc2c2ea1e4cb18285bbf1f2ba13f1f08f8da7895465e87ae5e781b0fc435"
    sha256 cellar: :any_skip_relocation, catalina:       "04ff5b94d0ac4d88d371b83254643f5923c5f4d70ca0aab76e094f4cd2f43af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf95e474f1791541043836146bd9032500d38e7a76a8ad9eff57b1a21bf8f4f"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
