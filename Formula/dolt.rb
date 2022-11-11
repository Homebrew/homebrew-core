class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.15.tar.gz"
  sha256 "da4bf4bd42d62330f185c3a7a6165ca50725362642191f6d59d2c804e51286d4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14fed07f44b9a386dfe9ed72e9e15abe0088572b1d55c18690645770e285a34b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16f10f0b99b5b34ee60a26e7bd50844c2db547656540597685bea54f0fe4a487"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee1f011ea59dcd4d3c45400e60b9f2b92d0eaead2862a305e41590f4a0a3ee69"
    sha256 cellar: :any_skip_relocation, monterey:       "da3fadf62dba9a8d44d2530d45a7f2f902747d06bab94c366c1a70320a555277"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a4c3bee02feba4d8da7b60705fec26ec416aee3623e433bfe084f1fdece1168"
    sha256 cellar: :any_skip_relocation, catalina:       "cc3bf46d1dcfa70c36836d5f86521c34c3a3a2f1a3ad1cdd82c8c22057ab73eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ad59ba0c84ace401560b969f8fcacf1cc6e290339c89cfc829181f5cc863e8"
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
