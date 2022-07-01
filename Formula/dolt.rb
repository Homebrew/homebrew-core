class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.14.tar.gz"
  sha256 "f403bf90f0313aae6154a97d3c16fac89a8999c42b0b2ea09020dec599f795cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c541d25a462bb2672210d032c41f505aef51aeb45f9182c92594538c769013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b86cf1f4da9a304a882ef1ab21ba4bf6598ec32d3d7d41700467a8d0604a6a8"
    sha256 cellar: :any_skip_relocation, monterey:       "dbf3c2c2316857f6363e1ef2eb6817a9544e882728ece265b0eb745b98b12627"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b4c366ccf8bb92cf66143b1e475a77b5d074be6246af34e70b1114ff4edd730"
    sha256 cellar: :any_skip_relocation, catalina:       "53e095b284ade2b276cb7084f6829c0e7a28bf0385ddc57b4c9e018d75526799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d50625e4c7812cbb618cec86c2a7df7852ec336bd4aff72d78bb2b1fae9273"
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
