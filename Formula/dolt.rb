class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.27.4.tar.gz"
  sha256 "12a1187b6fefa65fb74290da9727b209b6bbea0c315deb1ec67ef06772c939a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a13134ba4d8c1c441371998e5564af016ff959fdc717a6a3e86b7a5fc35e7c6a"
    sha256 cellar: :any_skip_relocation, big_sur:       "cbafedd0f8804dc103733bd26e0275519e1b723ec4ffbb5192b59c82fa667f7f"
    sha256 cellar: :any_skip_relocation, catalina:      "bfcade935f748496a2267e663f30ced14f9a7828a989097418601b68186399b7"
    sha256 cellar: :any_skip_relocation, mojave:        "64fe2f3a1baedba79d6d855accd98b5f98f10b12f33aa85ab87b489c783d4ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad063f7fc5a14c108fd028bf73c78b6631c94b49c9647217a43c3bb5c628dbc"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
