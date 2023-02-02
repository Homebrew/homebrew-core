class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.19.tar.gz"
  sha256 "7862c6827088d84cb34c55a5040247c397e555a6ec3ff0f197b83f25a384668e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53ef5c18873ca29f943f1d6be10ed9a696ca64ce6810fd76524925387af373b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9afd56e32bdcf4afd9b51f8ccad2603e4b332a84f10d103c3e8555d170ddfb0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0720a19949b3ca6899d997130aab22f134f7ada6de575be0e60edecbaa62f3fb"
    sha256 cellar: :any_skip_relocation, ventura:        "e337acd9a38d823dfc153fa3f44a7956843a0b367a4d492ebe708dfafab4328c"
    sha256 cellar: :any_skip_relocation, monterey:       "0beaae0b2254296aacf516dedda057773b26080b1fd49f6527e7c8c14481f38e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0befc28ad6f0dc6dbdc89b85d1a824eeeaca5e3812104f31639628d39bddaf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c60cbbfc9589a2f439e909fd3c16bd4538eac09531ec0c732f14c6ffa103e3"
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
