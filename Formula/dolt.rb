class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.14.tar.gz"
  sha256 "52d12cf87f6d456c03835a78393e308ebe27d8f85f802b9e2c482367afe8cc26"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05c8ada5954ebc6edecbf95d5e46b08bda870b443c1e22ac662a6dafc3f9fee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05c8ada5954ebc6edecbf95d5e46b08bda870b443c1e22ac662a6dafc3f9fee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05c8ada5954ebc6edecbf95d5e46b08bda870b443c1e22ac662a6dafc3f9fee1"
    sha256 cellar: :any_skip_relocation, ventura:        "3378130f66e30e895c94aa44e933e3ad67c3d954634739acc3415c7b84bbfbcc"
    sha256 cellar: :any_skip_relocation, monterey:       "3378130f66e30e895c94aa44e933e3ad67c3d954634739acc3415c7b84bbfbcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3378130f66e30e895c94aa44e933e3ad67c3d954634739acc3415c7b84bbfbcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a992b4223aa63fa017c554f2b2651c01b7b65bdf228bc89c056137b008b3037"
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
