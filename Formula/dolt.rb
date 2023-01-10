class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.2.tar.gz"
  sha256 "042acc2e5faa184982aa6d20e81038ef3d39a14765a131979901fe61ac43000b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec5e21eae5ca83effcaa79ac8d9e4c2cef597dc5f09f51a74bd59ad4e53134e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd617668c7f8508d6407e708652cd94d9a84e9e7baf8936745b17ba847463ff6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46d55e2ea0c06e3335fbb7ac187aa7cd21fee3ac9b79b6662864e18a55b3766c"
    sha256 cellar: :any_skip_relocation, ventura:        "b74b13ac1ae8fee8395a26553c5b2dd37d9e181c5c84417b5cfa455047838377"
    sha256 cellar: :any_skip_relocation, monterey:       "c80e65281118b5171ba0f78d2ee9aea5538894dd46793c8b888f6742a4fe2914"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f11159853c6889e684b77bba915acc88111e13f092ce9759c3351186e93760c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4497169c0e5aa19c69c427d503d616ddce65d400e15623507c0ec47d12998e4d"
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
