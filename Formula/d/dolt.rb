class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.17.tar.gz"
  sha256 "536c6a44af243f11d316b09a960f0c544e97d58e6218e62a0f8ec817b60d56ef"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8b8bb3ba537adc1e49b0517e043d8a688228b8dd0c9740bc538173521749909"
    sha256 cellar: :any,                 arm64_sequoia: "002ec40a9523544686199939a2237d27c238d66b04794e74176ed13713bfee0e"
    sha256 cellar: :any,                 arm64_sonoma:  "aad9af7cd8caee30f7eb31a28d69f9ca8a2306b4df51d285749a6235cff4faff"
    sha256 cellar: :any,                 sonoma:        "2c5a8b26c92a70ebc902f172360061e14de2fa5d417e7cc20cac87468bb06239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb7c7ae00be6704ba0e778b2d4f8f8ecf202a781e93b3dd6c791517bba061768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd599512cb6afd7da591133ad8dc26b8813d180e1bc92c4e02ffee21f08befe"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
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
