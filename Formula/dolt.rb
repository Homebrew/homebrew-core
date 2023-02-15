class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.53.0.tar.gz"
  sha256 "76c7607b41d470782b2af01bbaea2c32b141fd696a386b419f660e5a3178fd14"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e44212d773526c8b7ac83d18a706829b1cfb64010994c9f1e655291cde20ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0e5064a407ece96a2ab60301a550c514a00280472a8962dcf2804747ee7731"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c11443852f44e6e1ab2df0311668bb2232bc25f985dee76c69967cf3ee8b5ee"
    sha256 cellar: :any_skip_relocation, ventura:        "77da02df6e589b8093d906f7481e252e2700665b47719251934f379924575a6e"
    sha256 cellar: :any_skip_relocation, monterey:       "bcbf00dc2479921d8e695aa0c21d6a7b62e70c528fe006fdd20d11a259f1e584"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9e955f43ba67d9569c918d35f9851efacc4318568ff29ced3f90cf431ef3b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cbe92183c4b63488b83fa7c180075f4a56d35e9ec474621b320a55813d908ca"
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
