class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.30.1.tar.gz"
  sha256 "366c0720a3db080659a102ffe210c4dcba8039e39c9eb6b64d9d30c0a8300cd7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70c73b05ed074b21a1255c4268c96bc6c67701ca0e32c5a016897bfec4d07ea7"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fe0e2a4af2dd25902c2e71a47852ca8a696376804300188e729e6b9115e72e5"
    sha256 cellar: :any_skip_relocation, catalina:      "b68157b874b7dc52a2ca1efd9347cec43f39d6afb02b5ad4d7113fc91d8a74d3"
    sha256 cellar: :any_skip_relocation, mojave:        "33999997e951c0d02bf5a438fe35a30b1306452fbb72b003d5960da4f6f5ec90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48da7f2eabf7e634411b20da59a64a86d90972c2c4e2f9b56b9e2280ebbd1460"
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
