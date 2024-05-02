class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.12.tar.gz"
  sha256 "1a8605359d04e064fc67a4320f8b76ee900b9111e51cc966dbbc8db9d779386f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59b788ac4b6551444ba7f7caf1dff4481728b7e4c6946001e279551fbd014dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77bfd168a179eddd87d506f46441596a10ef530980bed7707b3ef196230718a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c75a815315f5ea37c6574ea31e11931e684067f27872e52524e8c8c53e65575"
    sha256 cellar: :any_skip_relocation, sonoma:         "dca2a24a900d5fdc2c5a73b6db134af71c39dcb81964bf8fee238ef11a7eb538"
    sha256 cellar: :any_skip_relocation, ventura:        "94643537489edec68b17765d36b93c0522b2e6e6578d3414beeaa80efbea66b9"
    sha256 cellar: :any_skip_relocation, monterey:       "8c6eb2a5b57b6e0187d5a83807e2c9886b4cd1d0aea1bce75e8e362713836878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27cf57b229dbae204f15e5dd0e0e249032ca568d49809350439884be52c7ef1b"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
