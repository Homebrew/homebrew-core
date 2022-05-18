class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.3.tar.gz"
  sha256 "a6cdc4108e1c2c5f667dc148604e1a080603b5fa2eeab57e4c31ba8877c61717"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f530ada602c9f636641dcac6ce721170bebe6cbd043bfe8284db8100339a1b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cc760710f8b01a10377e48480bcb8825e8107d6515863fd6a597ad66f32c252"
    sha256 cellar: :any_skip_relocation, monterey:       "8e1641eed7ea3b42de10d0971697bfe9476c6f260659d199b26e2ab9d453e619"
    sha256 cellar: :any_skip_relocation, big_sur:        "529beba57f992a65ac306830590540d56eadc18d92e7291797b9e3d9023e9486"
    sha256 cellar: :any_skip_relocation, catalina:       "81f7b529481617c48a64235d7b054f78cccb2544d5def0a9555065299ddc7937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67d16008600d8de01076760a4c751bc20e76a3938fb1dd667d511fd38920300f"
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
