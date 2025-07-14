class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.55.5.tar.gz"
  sha256 "fef41f6fb0b8f6891cfc076acb1c4630b23d76bdb7ff398fbcf90dcdeec776df"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce1e3dfade604818a3148911a5fc0dbc20ef605830554acd85b4d227434e7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d5da7de41711c504aa9256bba9d0047872085232dd27fcf867d00e4302e140"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d41a9a643aad0d6dbf3115496ed11d93b48cfeb1f5c202c83c3dd7579cf63c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf93805551c0caa618cbd039605daa683394aa3d2b771dbabb7b30f00dae94b"
    sha256 cellar: :any_skip_relocation, ventura:       "1a9753fad9463da2063485dfcb870e456c76c3f24ace2c2bebad3e0ec525832d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dfb41b1204826a878178df5dc254db1f267b49a2a30eee1d8cebba855452bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56453c283c23b0fcc70200e83c90361bd9be8fb02a65e598ea459b8030c5dce9"
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
