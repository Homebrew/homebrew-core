class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.32.1.tar.gz"
  sha256 "5fbd54d1cd0e6cb8ffc0e601644b245acc9cd11ea2da81a9862d0497451ffb05"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48aed178fe66d651a8263ae315a62b3bbc0ae87d9562d66b2ae5e4cb3cab0afa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7bc1e79ad4541194d5b54dbd57b39dd57a986916b44d5dbaf81dc4dabfeff00"
    sha256 cellar: :any_skip_relocation, monterey:       "76fc6cd8c6f38bfa84cce422f49cde71d8d115051ff2f964e170ce47134ba7bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ac401620469b8844d07292b2dda6ae88025d0d7b78e544f5868ff057ed11940"
    sha256 cellar: :any_skip_relocation, catalina:       "9b7ebc006e2d852788ab963f59fb6c30415de40d38f53da33bb917357f3a6cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb868ef032455701ca0be8fd9e4910543ba1b810807ae37adf95a118298262b"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
