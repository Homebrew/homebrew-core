class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.9.0.tar.gz"
  sha256 "fa425e599403f57a7f13b951adf3290486b47a3a16ff646825dbd1d6562c915f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f24e4a56c7ec9fc905de3f34dac3f696836f9784df1d0491578ab40d83921cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34e501355433bc863b49ad68c108cf8230d733d18a67dc15d24686cf917c5163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd8675e9c8823c2841089be6367647cebd6dfb848849ef94ac0e2a0b29c6e862"
    sha256 cellar: :any_skip_relocation, ventura:        "3807a8fa81af01ce913f68bbfc4640dca8566abdeca1f1c1b62523f15508dcf6"
    sha256 cellar: :any_skip_relocation, monterey:       "484cc4cff025385d9c459b77757e2dc32c55ca52a2ab1078a8b12ca395f6772f"
    sha256 cellar: :any_skip_relocation, big_sur:        "238b6c2da13cce268185f3837e593f02585b0e41f4f0bddbd47e739035d73403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92954d19db7c76744dd427a97c561bc1b8cfffc6381fbd66e70f3ba0442bfcc2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
