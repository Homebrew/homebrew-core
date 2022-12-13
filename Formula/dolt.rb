class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.12.tar.gz"
  sha256 "59516a1c9dc887961cba6cc434360f0c456ffc9e979cf141c228f412472a2c8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccb3b862655be5455b5071946048dff4f93532f6c087a072d603685b327c8b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd1f6f010d2ad3668f46adfee1e018b34e3a4940a98b4c05cd3e72d315b668e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2474cd682acf6b962940a8627f439ad18ed4adfadb8df87d73fbd1306b0c2d82"
    sha256 cellar: :any_skip_relocation, ventura:        "c21a5c81f3890e944b5ecc2b238f59a99c62279ae8fd463e359618ef417036b8"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8ad92eac94edf3f734f180cabdec5e289fe1ed4876ca9599e2fdf0b5ed4acf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2942ce386c6f39397539af64519d80f920603700b30651a0639d50628d1ffb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28117699a05e19debd0bf441648bba4c3108466935f3942d21f0efeaa0959c29"
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
