class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.7.tar.gz"
  sha256 "8f918883b9129cb740e3ade1d81c6c45678ef45213afc393ad8ec876f0ecf31f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7eedfe1ec368b12a3d700cfe0f6a00ee6f76dee6d02421c6e2e8ee69ac051a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "439671e9470c0904a2b184474c55c1551b3e408c88c5f0d7979c3b1a197b9ebd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c9f7b3287e0acf4c193ab8bbb7f2f04da52a359763548541332922523581a86"
    sha256 cellar: :any_skip_relocation, monterey:       "a9fc019482c568c068c11b2331fa4307758193dc367b6706a03e1b66695f7256"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb37b28ab79e19a42e4200d0daec12c02e2b4ab00626d5fe6039e1cb2ecb2434"
    sha256 cellar: :any_skip_relocation, catalina:       "fbf04f16db11a6bd751efee22bf03ebc24483c67ca09c135d0be63a60c3bba48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df86664e4803bd326b9e2d64e22a8ff0f6599d029d2bc977d6306fbc23343072"
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
