class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "99a2ffc82494eb370e98555533d2cda40cedcc548cd61130a71fe8e2e9bbcf90"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9121299718dd08758a2a54e481c31ad22110e65aeb1f801d2c94a8990941445b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e86faf11e685dea44dcae7d28a6d2911d97570b6e4ecb34f1e088f64ae1aee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8cfb06d1ea0546d35f72f09085da858f90f802c01957bba2104e474488b8f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2ea53b021732e03166c9c285d6c5a369130efbe20a5b72e1cc679a1e02911f"
    sha256 cellar: :any_skip_relocation, ventura:       "42b79fcf49efeaf42719f37bb114a34ac31c92c6f40a4f493f1d7971eeff5d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b8108b88ebb92a91c595021cf86f995f793e65d31d783da8921778675ecd54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe992e06f61fbedaa8098fdba1897d7e100cfbe7ab60655572dfd0f371861ed"
  end

  depends_on "go" => :build

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
