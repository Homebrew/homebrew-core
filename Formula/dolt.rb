class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.9.tar.gz"
  sha256 "8fbf31f5fcb8a2c18d226b2b847d546c2d090ff86f758a37e736a8e96ec8f8fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7cb47d66ac7845845d95c1a9fb098578234577c7dafb91f01dd66e853f2e755"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2ee7e7c1e229a0fa3db9c4ed24a9b81f715363e36c23ff52a06ffd3c5e99319"
    sha256 cellar: :any_skip_relocation, monterey:       "aff1d217eb7f329268b128be8baf1398fe0ab6a9ecd4bfbe7bc8c34dfd7835d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebf11a352c3f15db26bb95ba717261960a9b5f2ff524cb4439b102fffed927f9"
    sha256 cellar: :any_skip_relocation, catalina:       "13116c3665c74307e8666dbc288c41a5b5ab130c7d527abe77746ff9bf037e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f32aef5425f805f01065dafd73e540f082dbe5a12b8d88eb40e719f432b7fbaa"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
