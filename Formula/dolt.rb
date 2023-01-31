class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.15.tar.gz"
  sha256 "be6cda15cb32a929327d93b3cc2309c85584de8dda64b95cc23604f59913c564"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75cc637d9939008f49b56f6a3589909c60671385dea6b3f75734ef561d625c07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec835276b156925be22bacc63af56d4a5b37955f0eee2ac69b587d3f30ec5894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f8c8f6ea00e4aacd96736c5fba4e662519abac4c9c787794202199ede371dfb"
    sha256 cellar: :any_skip_relocation, ventura:        "b42e8eaed2fa538b59b4751981c2964312c5bda78ec3b77f3f40b4516cca91cf"
    sha256 cellar: :any_skip_relocation, monterey:       "bbbee3c4950b946f97d763fac60a86eef1fdc644903a54cbcafcbed257847339"
    sha256 cellar: :any_skip_relocation, big_sur:        "4563ffd181eaa18cc19acba90a6144252145d970a124b8593db1561aebbc4496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e77e07a3dd2f8b8f74431f8a5f995229c8b9ac2a46202d94f79869d278ae15a"
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
