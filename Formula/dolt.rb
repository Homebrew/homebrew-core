class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.8.tar.gz"
  sha256 "596239cea5a66127bf31ab8293691e442886c27b75c4875b2f8b06d8e9551b63"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd5c20bdbb3b49fcf342568d64d5ce26f3dc64902abd24559d96e79ebc9b3c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa1c04d315753dfb8787d32c008330171a6c6379426718da018076ed60c9d29b"
    sha256 cellar: :any_skip_relocation, monterey:       "111cb9c402e52c9ecf6cae4f5584ed440d18951b8e182316bfb8308f0f13587f"
    sha256 cellar: :any_skip_relocation, big_sur:        "027b976d2a27e33e87c81eda686344b10866aaa663b7813f936b8410e7879e0b"
    sha256 cellar: :any_skip_relocation, catalina:       "05cb8ad6aee572405339ce6a18b9b44d2bd2f99bcf0f30cc77fa41c2bd691d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66dcd4fc953e47737638afae8083bedb385d62c47fcb305c61231bf4a54a669"
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
