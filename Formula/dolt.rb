class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.7.tar.gz"
  sha256 "03346361bb73d3d146e79b3cd43801bb31477983f36fa725f50c7c56c34835e9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0400e7e7cf993ea0d01c03145801d8f45454e428022e91fd7fcf5a6c757a28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "128177a1853b1eb08400589bafea88de033a2c7637bcc672d7a71817ffe5e8c4"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e7f9009ed09c2533cde2b520aa444f7ed2ba69216c5be8e40e1b4ec3d61409"
    sha256 cellar: :any_skip_relocation, big_sur:        "99d280eeef8c0b02bed14c2473c6a8ab1ccc2ad1186342dd179ca55d94e6625d"
    sha256 cellar: :any_skip_relocation, catalina:       "550b76d1e0a8b916fdbba423e45169e6a8fad20a0b499ef3925192b9df3cdc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8734ff08bd5dcd8cfb5088dd592acd97a0d81095ad359b9689f9529a4ef00042"
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
