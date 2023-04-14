class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.11.tar.gz"
  sha256 "a9b870644d362a8c3d9a69deb1822fe5b5320b72b9f49cd04291803a2b488efc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39d521b1c041a1e83c802532dc77d065d9c5741eb5ad7549cf3d342b47b16459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d521b1c041a1e83c802532dc77d065d9c5741eb5ad7549cf3d342b47b16459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d521b1c041a1e83c802532dc77d065d9c5741eb5ad7549cf3d342b47b16459"
    sha256 cellar: :any_skip_relocation, ventura:        "928e586473970b3b8b83c365672dfeb41543d0d8b08f67a1e3f74ab62011f3a5"
    sha256 cellar: :any_skip_relocation, monterey:       "928e586473970b3b8b83c365672dfeb41543d0d8b08f67a1e3f74ab62011f3a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "928e586473970b3b8b83c365672dfeb41543d0d8b08f67a1e3f74ab62011f3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01648267be9faea1eda23bd91c825128cb4706c87ed51905f2865af2a436fb6"
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
