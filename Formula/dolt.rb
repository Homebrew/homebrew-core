class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.17.tar.gz"
  sha256 "c7b49effb9693bcd341add5907bd849bbdd65c54dac0b11c07fe34dfe0a8158a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0efd9667f309192dc87e014e78b4f42077c644ebe8b082d94971c76792a3cc95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a862bbfd2dacb420571f432912aa768c85b5207f362866db2ef8a03e594713dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6d9f2b11fe1eb93c616d2f018e6bb0a452dd843272073e17b0b17c82fb85f48"
    sha256 cellar: :any_skip_relocation, ventura:        "5eb535b3de8cd4aaef62344a1fe420bd2c100eb3fea8efbc2a865456783381ea"
    sha256 cellar: :any_skip_relocation, monterey:       "53a717bf8ca8b089e030fb3f25870a3475323e753870f6ab57885fad993cb0d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bea3c41ca0787ab107de295fc9f4709b93e9e100b64396723eb9fa19bcf8ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c105b7944dd0343807875cbc1669bc371615959a665fd89cbb7cca7eb5fe1a3"
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
