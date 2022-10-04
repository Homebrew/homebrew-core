class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.1.tar.gz"
  sha256 "b24de2111142d33891176a74dc6e4bdc994c8e7d0436b4dc90763a48bf4b4f9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23f5d98d0c8a8e4e26f19a4c587f8fddc7a68839fac38774b817b57ceb82134c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9ef04e6db82d642385c3373f74dd4a4ad04ab43ea3a35d39737c8083b103749"
    sha256 cellar: :any_skip_relocation, monterey:       "44f221bd2ffb1c6c12670718e1a64205ed3104861044ae2deba8747a961213b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "285992d37e036b7c540f89862e4f5be5a8a774c08f312462692217503c0ac2be"
    sha256 cellar: :any_skip_relocation, catalina:       "a9d4627313b332877d25a7ec2fefc12a717f03f7b05ab525e4cef094a98c74e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f45f1df95c4ddb57912315609f5ef865ed0508a760e62022d23c4286f40e303"
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
