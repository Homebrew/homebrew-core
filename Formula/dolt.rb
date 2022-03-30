class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.8.tar.gz"
  sha256 "36b36b3778eb58e5ae6be9ee9718c6fb2f92e2ed0801f72471080ef36141d892"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4c0e08dcb1b772f1e9088c3cf9ebee2a188de70788c4bd987cf75d2fe200983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2159d2a606cbd7b3b08165adca47af0f6db9dc616ef124eccd6d1ab02ecfe7ae"
    sha256 cellar: :any_skip_relocation, monterey:       "b9b85ff8599829cda4c17f5bfe692ad24f81fc999ba3b5c66fedfeb710c6b5fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "068ff132000808a113eb92091838ea3b758fca02fe1e63d2e0c889fe4f729a93"
    sha256 cellar: :any_skip_relocation, catalina:       "5f47671e5ce8dea81c566a47fcb5159a455e2546a4ca90b77b94eb24b40987b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4d3247b71aae199b49d5fd89309bfc2e677e94cb826f0c490ad5ffbf3352609"
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
