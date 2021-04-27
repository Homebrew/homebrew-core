class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.2.tar.gz"
  sha256 "fddb493a6d2f9dfe2abce5693f9a0a13ffa89c50af2ff62576e02f3bb59aa733"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b931ce3ff8ac8ae4e34520ad355a5c6d3e3a596d964522f1a1a56aeaa4f95c80"
    sha256 cellar: :any_skip_relocation, big_sur:       "69af7032ab7a2c3fd3c7f813c459d52544f3ae677c6e705b2fbf53e1bbe923b3"
    sha256 cellar: :any_skip_relocation, catalina:      "cdf4f6ff556444ff0450638397fda18d7395dc05d64d428b43c3ff6dc823765d"
    sha256 cellar: :any_skip_relocation, mojave:        "a2b12cf27a8211e6f3b8d19ded12c562d5641e8e2f32810f2f61cda4f5757921"
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
