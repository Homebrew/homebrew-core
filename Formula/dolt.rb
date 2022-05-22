class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.4.tar.gz"
  sha256 "29e748422207a1b67abe2b04f1d81d2a123c750c662d7de01007b0f6c13c9f5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fca3678eb9ef4a49beaca82db327688679dd5bf17a540773ace9b8bccbba49b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "910f642356a1b073e041bc52d84c2a11d54781d226964b8d6761eaa91f2c51ea"
    sha256 cellar: :any_skip_relocation, monterey:       "2b820b7eec5ccc3f908dbc9f89e1a31c991fc78dae22ac5ecce22bd77b161ba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b7c844a00d6a01823fe1030f189863445648084932deb00c0bd5ec184019cb3"
    sha256 cellar: :any_skip_relocation, catalina:       "396528b3578fa20a8dea4e5997e57fa278591b3ecfe7280193eea3895fba4a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6564c408f8408b211961c856c1c3182cdf95afc551bb8dd999da4acf331860"
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
