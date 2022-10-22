class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.8.tar.gz"
  sha256 "d4c7fb45ade98bf4277be286a04d8b7be0d50ac4165b821e04e1e96e16ce7871"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d134888ecd2e70c698fd41e910c2cfa21dd15d33cee7e10b8e6aa4598dd96d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee0f50fc0c7863e1cbd99a13bce858ca4e4e70ca855eb4bd6434bc389ac2c0c1"
    sha256 cellar: :any_skip_relocation, monterey:       "bba480125e29f8d2314e1c08d8c1dc246949ffa5e995e560712fde42825a2ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "67d1bf2fffbf0f8cec419ddb93815c0762a35c939bb57528a4783cb974ce28bc"
    sha256 cellar: :any_skip_relocation, catalina:       "803e3575cc973693025db51a1658a4adfc1210cde05718609b0e78e883a29f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c7d0dbc3caf7ed616d75fac29cb26b8c0d9a7fcb69f930d1d7c4321c00bb8be"
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
