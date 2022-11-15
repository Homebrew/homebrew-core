class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.0.tar.gz"
  sha256 "f1768f68321e1f84b66099fb41dc6f0bd6c170fc2b924dced25a16c60af2f43e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09afe891508f130f3057f4649c807b2d8429946f6ee808e70b0c754022b86990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cbb685fe78248ad551876fc1bef688a46a35360587fb5a593e0e8d0526f19ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71d51e29b809002ffba97298f1d9e28f49983f0911e3f2fd6ea8afcb59eaf918"
    sha256 cellar: :any_skip_relocation, monterey:       "6805bd27e76889779718eea88c5c1a61495ffb96f8ffaab8d7ef5e04afe2482c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7caa40625adbdac05e8fa1a4dfa99a61343f58b4fc8abc0c92649660d8f39057"
    sha256 cellar: :any_skip_relocation, catalina:       "a739a5f0360db00c9d0e781440229f6c8d690898f537d627f4bf887e453ad4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d382d25f6d44a97d37aaab7a4547fdf40647a91a6dd30e56f68f05c219958db1"
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
