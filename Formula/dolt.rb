class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.23.8.tar.gz"
  sha256 "767cb0aceab875ee8404b3aa6bac008b8ecb2c9cba314524c18a2aa4f0278928"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0306866b0f9398b7690a325197308c3d785b868abf5f584734a8a9f87b064cc1"
    sha256 cellar: :any_skip_relocation, big_sur:       "07dbab14ddb7b3c2c52d5af3db421b337ee594dc89d0a32f20325f321cf65e33"
    sha256 cellar: :any_skip_relocation, catalina:      "c2c1261efcf33178fcf81c97d651883b0a021a92cee0e8ade2bd7ef97ac72f79"
    sha256 cellar: :any_skip_relocation, mojave:        "15e723b6f1ff38e6263d464137dbe9a97583e47f423cf2386ea2367d876efc72"
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
