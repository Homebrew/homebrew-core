class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.39.1.tar.gz"
  sha256 "c09256cf97662b16d038f884b3a8cf97e5a9043020ebb1b1b7b1b344fa556520"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e28cbe9ac969e5c207f30f6516678f6379103e81a617a2b494c1d8d7c395257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ecc9d40fe229e8fe5caecb4559dcc34f388070a8a7fe9cdfe9ea0385f97c1ed"
    sha256 cellar: :any_skip_relocation, monterey:       "9da2935bf369e818a2979a23d52472a578c72cbdb28261585ab6338ba5a1ca9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6ebd8bc360208dbe77b032aa1cabc9b511ae4840e969f1e5118bb44bdba02de"
    sha256 cellar: :any_skip_relocation, catalina:       "84b5d9d4bf9e805f17034755f4f840edea54103647cdeecb3b89beb897060e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6e31460b7db3069f2e497aeac6a2a86bf692c02b3efef0fe4436b0e2e5d7d6"
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
