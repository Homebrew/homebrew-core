class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "dd71c2decee224e5b06dd0ea30239eae9106e4086c611077dd21bb07300b161a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33c05f50bea6bdf6679492631bd54b48ee87ec1c613bba1b28e12ada4e8b6a30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8a97cd99c12b5d09d49e8b6b042e5913af50e1887a9e8d7e889292d67478ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f635e6137c184467a8c769e2f85bd4c561a621cc3b6aef59b22565ccf312850"
    sha256 cellar: :any_skip_relocation, sonoma:         "db399fba11f26f66ea26de39633825aef4ee0cea604fa5c26e08906ec89237f1"
    sha256 cellar: :any_skip_relocation, ventura:        "84b0642cd1cd27fcc332d3fcd4835c16f00c64632e710405584149b66f9b2629"
    sha256 cellar: :any_skip_relocation, monterey:       "9db8e6efc553bc58774ba89f2d1c44f2b16e7b78f73a655df61725f1b813dfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f207335681d011e3791f1d1feb94353b8c25ec8bcf13a7a3c3e94b35764a3d"
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
