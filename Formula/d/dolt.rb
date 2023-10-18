class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3c89beec6ea401d848f6c7d7937a98ef164e74233ff051de69daaa01cb154f7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7dee594ca49bb9eebdef88d04984bbc22719c3e3e3307a62e02245d3c9505db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fba644d4ee1b05ad59e20954a4398d34af4ce4740971a1df97709662b9e720a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cca631a5a96e8d2043b1d2fee02bc437f6ff686ca7528caa36a5e4a368653e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "094f13eefb111b06bfee36806ef1d3fe372b29157c0026ec7608cf592e7f065e"
    sha256 cellar: :any_skip_relocation, ventura:        "156f129a365530542420a64e369d58661213eb94a4efb35ddeb27357373ded22"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa0534e0c28f781c8e19ec71be16d641bcdf3d7802fef062e343e6df27b2600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b50b26a37cde595caa24bee6e66a8dfde111e0e8f5ea339b61fdceb1e0ca07"
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
