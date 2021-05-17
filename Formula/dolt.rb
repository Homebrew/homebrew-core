class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.4.tar.gz"
  sha256 "b3be438e88f3daa03a9ace88197074136bfc56478e0914a788a43ce707731c9f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c116abf98a61717c4de8199b3b97b5c2d52d94b11f669aa38766f9f0eed50f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4db7efc4da0327c261f25803a6b1a4692505be9a7a17473841ed4e22eb56cba7"
    sha256 cellar: :any_skip_relocation, catalina:      "9fa68366b7d56889199517d10112a3641b6be410e6e7f9ffed690e8e9df0e5da"
    sha256 cellar: :any_skip_relocation, mojave:        "081691e8e4d005af42c879affaadddc78ed9489537dff9d5eabf7b1392a291fc"
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
