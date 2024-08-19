class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.42.13.tar.gz"
  sha256 "913537a130db4403496266559f4902cf2c496589fa67d14d3ca8476ab2af0e8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053479d03c58cb1a4c0492b163bc2eb7af5251d166310d1fb8880d149f01e563"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c788d98fc910dd606e30b5b68f2cc2a0690e51c5073aa01354ac8a12c07fcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dafad63563a64564adfdfc4c5722e434d9486f8c4d511ced9739259666fbfd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d4238603ce543de199d2fcb8384015d7a9875969343472fc69a2b24022cb354"
    sha256 cellar: :any_skip_relocation, ventura:        "8d711fee0308b020ddcd1a9603d9b9f15452698019c7b735361655fde18b51c5"
    sha256 cellar: :any_skip_relocation, monterey:       "9ba8cf3402ab8383f51cecfd4600a031097f3acf39da39c4a2766b5d6f79baaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0cfcae417f62f0bf6cecf22bd0048cafe2612da565a95dc4bfe21ac336c7f01"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
