class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.22.tar.gz"
  sha256 "74300a14202b4b47b09135dcdac696411845bf1d88795bdf8e2f9acc76296d2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21d566574e1d8d6fe7578aa0c8f987b6d4deb84f7c0b6e2e215b846e764229d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a804b099814dee50cc6915619cbe6dffd4f128ab81e9e5748e581bc39de1833"
    sha256 cellar: :any_skip_relocation, monterey:       "c4b257564783a7c789a1980d6d64048ad964ac28ad1a059604e26e3cb072788e"
    sha256 cellar: :any_skip_relocation, big_sur:        "89695a45f1f21cd3282ae1735194572227d7e6ba3c09156d20d06eb9eda1abf0"
    sha256 cellar: :any_skip_relocation, catalina:       "f6760f41ea1bc3518e0f176fe77e135f14e74590f38c95e1edbc138b655ce71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5588ca490032fde3efe340070a1de7cb9a8e67a7daf98faaeebdd608c6684e8"
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
