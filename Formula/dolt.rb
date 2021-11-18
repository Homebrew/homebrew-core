class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.3.tar.gz"
  sha256 "5cd7680a174e4e1dc3cd6c8816d6c50b0c8194a1df3a2b394cb5a53eb644c1ff"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d3e05a5aac7256a5d9e6f279b0ad366a0de94285c3b8b7472dba0254ccb429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea42f7656748b73f2af64a3c4dce4a5a508b98f7b1d6a5d912babb28e87974f9"
    sha256 cellar: :any_skip_relocation, monterey:       "47a7950313645a4db3899b91cec09c28f30c306fb5881db32fb5b538ff75ebb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f2dc04b6a300956c0274df31f795272750c2666c64ffef1ae3c7f71490b5451"
    sha256 cellar: :any_skip_relocation, catalina:       "a40d431c81ee766086767cbc1548f19104fdf5af6b3408a3943688f134a9c980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f9ad8525f881390dd9f92422f2a310203d1072f6488af7c301f9ca502561b8"
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
