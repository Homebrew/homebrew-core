class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.4.tar.gz"
  sha256 "fcf954d2552639aa09276c4786fb15324d641758ace7f1567b3c0b31269c9a85"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc7aa4fe69a2e29d18d975370eeb5985d952fe91c26ca76f08ca2b8fbeaea325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc7aa4fe69a2e29d18d975370eeb5985d952fe91c26ca76f08ca2b8fbeaea325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc7aa4fe69a2e29d18d975370eeb5985d952fe91c26ca76f08ca2b8fbeaea325"
    sha256 cellar: :any_skip_relocation, ventura:        "a7f56dd12f3f6d28ae9695f53c1f9d3f4d2860eae3f9363ced535bc196883938"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f56dd12f3f6d28ae9695f53c1f9d3f4d2860eae3f9363ced535bc196883938"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7f56dd12f3f6d28ae9695f53c1f9d3f4d2860eae3f9363ced535bc196883938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "801c9745636b60a9e19eb05d0e8e8492d543ede1b6ee93deaa6bc0c60118cf84"
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
