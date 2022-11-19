class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.4.tar.gz"
  sha256 "1a3c9ffc6c90cc99d9dbc881505e4b9a9b1e31d44832215b5331d8a4a933c90c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a437ce8d6d4b28631228441013f74019583a21084bbdbd3a5c9a731a321baeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e342c1c64ac250df50328248baf1ec0e8ca128dcaad5ded50d2873523f5db4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d6e076333db6658aa977aab987daf07d358f392f7c43d00149f93128911756e"
    sha256 cellar: :any_skip_relocation, monterey:       "dacff3e18955189130bd8ded874a7080fe0226a5c0e7832f8c41116d5b735009"
    sha256 cellar: :any_skip_relocation, big_sur:        "04bced54c391a883534d071f3a35d84481128f37d2de1fdaf1aea9f601f7a73c"
    sha256 cellar: :any_skip_relocation, catalina:       "ecb5881e5bbf4b9014513171fa50109fb974795c21d969834f26e8017923dce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889f6c1e0665ffa3e6b567b5c0a3ff25992ff369806881185e566e37b309b0f0"
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
