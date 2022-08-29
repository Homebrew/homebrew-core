class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.30.tar.gz"
  sha256 "6c1ab07a2d0a7d6c8e76f8e6b576c3a003fdf7f1c9020e91bd25a53c8a6d2976"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f593d6f5c8b0b8a8262166f16999b340962948f8cc8855a7eb35fc7428c68f74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57229b924ed669b62c2895e0dadf30a28ee509ac7e7ddac31dd609d5842ca860"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ebca109400785facf479decec2f6904a4cad095cf3e86e827f0e8ba8c4b308"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe5ee1f1ca9ded8e5ad973dd52ba91e95677f0e4bb23266160f91cdaee104a21"
    sha256 cellar: :any_skip_relocation, catalina:       "82b9de023a842a4d4bfec5bcf0da4ebd70b4183c4f502ecea39adf041f192a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84731860d0b0f1e27f47a9b63944c4acc47681aba6b08c9bb48bc7a7917e4e4"
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
