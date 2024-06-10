class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.39.4.tar.gz"
  sha256 "3ea86fbf259c8dafbc110b65ab10c4883120b8b5b9ebfb1b5b8a1afb9e3cca43"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b82de991a4dd5931e7e94d9a03796d20e4ccaf2f3371532df38fb7d93fcb8f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66c93d80ef419fb5b979b72f86831fef5b8a29428844aaed47cca7aceac9014e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a9829319bc1df2908f9964d0a5142c907d0ce772d2c6dcbc8928dbcf8da5088"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab0dd204b39f94938fdbaa8892f83e5f891a88d9ddfbe861c20598c5330c687e"
    sha256 cellar: :any_skip_relocation, ventura:        "50bede6ea7303ccc23153106b396e78aacd97f703b3475780546c7b85f873912"
    sha256 cellar: :any_skip_relocation, monterey:       "7679855307c34aa8f6977a6bed2b2bee801fd334cd4caffcce51a8b2268c27b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d415381c4fb0d4fcbbdb97f6b35f095b7bf2873a69bdb8170380cd26b3a203"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
