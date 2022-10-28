class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.10.tar.gz"
  sha256 "1ad868d0f38cece98e733f07f242ef6b0bcbe5733585bbb8c84808766609f0e0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b03cd456b1fbce3c72d28143239889460953dcc0ce7319352eb8b268b47df02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c400d45d7dfdb32116eb1164110ee19874c0501660ef1269d3d8a5d4d24d4dc0"
    sha256 cellar: :any_skip_relocation, monterey:       "b6d0f5e8985514e805834d551e7916bc8dc1bdfbf81120088239b03a56f2790a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f2bc88e6d005adc9aa7d7177b4a574311c332a44975b0afc0fcec2964d815ca"
    sha256 cellar: :any_skip_relocation, catalina:       "76802c91280690edec56534253fdbdbc255f2179052e2f572b8fb5864c74c832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f4adcd5ca8b8bad191fc9c1a2461d0dc3907dd07dd6302c03f69f59e2c7fc6"
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
