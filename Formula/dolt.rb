class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.6.1.tar.gz"
  sha256 "4ace2f6bd7d46fbc62cf125b455e1c13e7a7647918eee207a4a77862f76462c5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8585ac00054803ae38ad1f426374e91ea11d4692352e3271d4f3c9df307ea9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8585ac00054803ae38ad1f426374e91ea11d4692352e3271d4f3c9df307ea9e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8585ac00054803ae38ad1f426374e91ea11d4692352e3271d4f3c9df307ea9e6"
    sha256 cellar: :any_skip_relocation, ventura:        "f8118f312ab6f35c9536aaf803d753fa71d2bd04b2196e4f3eee4a453b9559ae"
    sha256 cellar: :any_skip_relocation, monterey:       "f8118f312ab6f35c9536aaf803d753fa71d2bd04b2196e4f3eee4a453b9559ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8118f312ab6f35c9536aaf803d753fa71d2bd04b2196e4f3eee4a453b9559ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dee11e41defa9532f4b634bd01ba0eb676e7b3153f84340a5a8da9e4e3dbcbb"
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
