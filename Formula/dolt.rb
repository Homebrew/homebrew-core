class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.18.tar.gz"
  sha256 "b20465194d1e3243a08f7565589483235c5f8cd224a1ea5b042af015cc53a2e5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4a86009af27a95fca76c7480a1aac2d31b650900e1db76052e7f76cc064e772"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0bd74c170c4089ee3d72cf1d243d35767976a7abea3dedd6d4e2d79b59d2d7a"
    sha256 cellar: :any_skip_relocation, monterey:       "bae882908838b7bbbdb3f7440a3fc63eb7b6eb2c01a6f2d07b5ae9bcf939673c"
    sha256 cellar: :any_skip_relocation, big_sur:        "853b6f492f1da0a07b6967eb23b55503ecaebb05386dbee9ad44ac6af477f43f"
    sha256 cellar: :any_skip_relocation, catalina:       "6ca4658b3b04a313b0711bb4b78e766dc1cffd67848caaee86de0db17b9d3480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536aab0b6a1d9217f25070deff10506360c10882b4465d97209dfd4ecb2edc6f"
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
