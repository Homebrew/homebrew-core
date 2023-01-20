class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.8.tar.gz"
  sha256 "6e152ebe2ffd1df5c93518e76baf1d9331c056e735ed1eb223007445b6f66e5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2070817b2cad2ef02b08e33ed81c54386d764b9a4ae31af6e975d2e4b641bc48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "339eafd1d9cc433f5e77dfe5a831f9ba3b81a662f1660e4813e1321fb88024fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8311fe9cedd46a0e51a51f74403dbe4db5e8150c99b08c2f5ff1a6531308abf"
    sha256 cellar: :any_skip_relocation, ventura:        "36f8f49c92fcdde5c88a0e70c617f0a74f9cff0088166ab2cc0c74983a89d6e7"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6309e1367fb2a1f31e3f0d6da3ccc91d89a3a71c4b58ce6d656def6a685bda"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea013a0a7de658249739b84a674d850fec5029b28aa8849974338130a6cfbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5eb644ea2fd71df8b5ded95f1d89275d47f8269913195ba62f081f8b2f1c9a8"
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
