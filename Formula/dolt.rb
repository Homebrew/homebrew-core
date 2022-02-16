class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.0.tar.gz"
  sha256 "6bac41db4fa46314a95b62a71b3a538cc0f04085c1502b6d87e9f8c6d5495d0c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd0c00593450ab7c16d39dbc39ccca73ad50d2426e291d59761b897554147982"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2cd28fac19063940c91dd30134936071d58e3af6b63d8236959c269bf4ca327"
    sha256 cellar: :any_skip_relocation, monterey:       "0674672eb0ec6dd6e4593d5ed4cbac225f045f8868f32c9bfec19b14b4985248"
    sha256 cellar: :any_skip_relocation, big_sur:        "b97704b5f40e27f1c83b7792666a7b228b56fa7b57273d43bba56b33da48f8bc"
    sha256 cellar: :any_skip_relocation, catalina:       "c9d75ca251de7e90204c4f1eeeef559b4c92c2af86e6fe9d08974e23dc9f603b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1da89718ce4507edefa0cf23a668b360748e928f435085e3070340cd96481c7"
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
