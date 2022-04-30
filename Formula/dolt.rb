class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.39.5.tar.gz"
  sha256 "d74b14575539375168f64854331eb2b7d80c1ac96307c0730208a144c727ba0e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9098b53cc3cc5ff8a412c0df3012cb7715c3cb1597dae5189795a45ef1f73af7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c463c0085045413fed5010239ccf66fd3c7e80719e4552bad99e029e0b5e279"
    sha256 cellar: :any_skip_relocation, monterey:       "ca47423b2ef25e91d0b4b15bda7f80c87d641ff4cac60599ca49ceb51dd5a931"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4639d9af4d9d6e3dda97bb4e9129625d9a90b8926f388bebbf97241e183beeb"
    sha256 cellar: :any_skip_relocation, catalina:       "a23633719c8fa67e5d00abf2544fdf3949647e3d4ef67db6dafd18fa24460ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fdbac8692656f1e84d7363a16f203b4f7af887b3939df0a5e91c49b16dc7dcb"
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
