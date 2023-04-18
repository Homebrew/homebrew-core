class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.12.tar.gz"
  sha256 "c6d34645969d4a3dded4bd0c2e7e83ed767d175f93c22dbcc8aae72e5632270e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba95600eef8294f28220f2e56f8b50fab4d310bb3a2ca69b13a36b29d861b57c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba95600eef8294f28220f2e56f8b50fab4d310bb3a2ca69b13a36b29d861b57c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba95600eef8294f28220f2e56f8b50fab4d310bb3a2ca69b13a36b29d861b57c"
    sha256 cellar: :any_skip_relocation, ventura:        "432041a959ee2229ae64d5513803ec6df027cfb9063d68952e6c5558eaa0a527"
    sha256 cellar: :any_skip_relocation, monterey:       "432041a959ee2229ae64d5513803ec6df027cfb9063d68952e6c5558eaa0a527"
    sha256 cellar: :any_skip_relocation, big_sur:        "432041a959ee2229ae64d5513803ec6df027cfb9063d68952e6c5558eaa0a527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875ee5e8355ad1e494da8af184b8e068ef80347d3c2c2973832495d0cb349c07"
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
