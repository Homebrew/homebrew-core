class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.39.4.tar.gz"
  sha256 "1bf49730295f54b9fd252599b6f0c8707dcf0e86ac9d976e16b53d4b15a23e7a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422a3726bcca3d3c8b359d6fe9d380115728eefb76347a01ea3b24891d335d6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6295ece36b0d1aaac70a63514f68214e3fcf19b74d65cb218acb0d0114b3d54"
    sha256 cellar: :any_skip_relocation, monterey:       "653f646e1ce5df0a03f184e5ebb8dfd489f3ebcbba69db4b12ef67bee1ee41bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "63080cb804f7304d76105b7be98630c4be4e7435e825852929eb061d8d5327a5"
    sha256 cellar: :any_skip_relocation, catalina:       "2aa38d1b6cecbc6afe4c3749de8c10af18076ae6e66d6b20abc1213bb96eeb4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a40ba794b5c058373b1c29b60f1d643c29ca8df2126100c1c603206a264374"
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
