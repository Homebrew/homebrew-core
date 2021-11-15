class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.1.tar.gz"
  sha256 "88c2d143431b8801b677d201456cc1096a12a2920c554ec994a30cab773cb005"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cf79c9e1327908f2fda475eb3da5216b3a238d95092ecbe68fdf9a91a3082f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af8d05fa01b6c5cb9da5661d08ec1b58f9c77f1e7ae55132eaf2a2d20e4e1f12"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9335edd860abe5bc0d62fc792fd52b7d5f0976b81d0acc8ffe197501db3f36"
    sha256 cellar: :any_skip_relocation, big_sur:        "1782fdc66bcfdc5081a29fd8b149e0a4ed00b07326e2f21c0aedc111abfc7539"
    sha256 cellar: :any_skip_relocation, catalina:       "ddd71d7a4952520f5ea253e7504e08ee4726596f80c8fb56061e0d7b6c887811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff69db2c42e12a9ed6d82ccf33d053d4f7cbb70a967143e7a2654c158890f0f"
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
