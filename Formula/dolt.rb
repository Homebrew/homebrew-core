class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.7.tar.gz"
  sha256 "26160fb6d199d3b01c69eb8beb580d9947b36afb8dac8255167c3c6772f1e2f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb00f0e1c49eaa5ec53f6c0a955f6a231beb20dfcd3b8f8eafd97b9302b40fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f035cd5dcb4e32d5922955e34188c13718eb617647472bd9306e8aaf77da493"
    sha256 cellar: :any_skip_relocation, monterey:       "5ac0fd7735a10b2cdbbfefae7e9cc5103bad4ed63d91ec04c2195574364ae120"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9163ff34476098c24f3b854c7287b2a0fe199c5f638b223bf89d1342ebf81c0"
    sha256 cellar: :any_skip_relocation, catalina:       "aac68e4a45485891daa0008388122cd34187e262acfd51d492f89d7cabf6e7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3892dc7c2455c0d9efb725fb8f3a053418c7a0ca234e3150b4f56770a2b1d63"
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
