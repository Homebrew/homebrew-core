class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.11.tar.gz"
  sha256 "3ef83395597d26cb4816bfd5943e65a9d4e924663de5bb4f502d2842bbbb1811"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14566807082fc7cdf4132b8126eb3793843e0e1e732a36307d435ccfbb8775cc"
    sha256 cellar: :any,                 arm64_sequoia: "6fe4837121623c281a99d9a5e1fdc81aa6d12559b0f80bf9fa23cec176639c2d"
    sha256 cellar: :any,                 arm64_sonoma:  "b59f772e851dbc812ec6358783ded491de1eddd75c3ed395386ff114679c6fb1"
    sha256 cellar: :any,                 sonoma:        "75d9eb8031bb12e3cdd3544ede92bd877e26856f0d6254d1a9aad841948b2d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4de2830b6569ccd483908bdc40b8104e05799c6e512dbdce49ffdcd7267b2634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a684d6e25baaeca7d4ce27e4425a73bc4acc7d1b53b7238b1f8e5419246de4"
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
