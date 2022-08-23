class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.28.tar.gz"
  sha256 "4f16e4bb21e84c6a0fc009287bfc38feb6809b2f2ea0f1aefe91b39f0a2e9433"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "814f2fa86ae47ee1dccc964095d0c9754672e03ffb5f6bb9c64eca14492962d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d49e0cd6c5590b7de8005c599b0a2e290f54ff7c09131f64bd9cfea46fcfb6"
    sha256 cellar: :any_skip_relocation, monterey:       "b3bcc47cb02263b8783b8220f09d8816833891dba2572b3593d5add4e7706e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "65a984b6f836561d2b7fecfa6ae9d945b5b4820a36aec32bf6b6eaa2d72e2ddb"
    sha256 cellar: :any_skip_relocation, catalina:       "f7e1e7ff9222d0c4ea86a23234c344a98194490e827d7d837178cb423ce10152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14478dda80253c950d196bc258912720fd01d3b51baf548220948ce7ff4c1401"
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
