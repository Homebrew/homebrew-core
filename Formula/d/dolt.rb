class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.83.8.tar.gz"
  sha256 "aa90eeeb79cd899af3260a064efef51c3db4c28cc2f3514dca893a3424a5ac16"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f043fee1e3f8b287704856c0e158babbdf3a0aa26ee008dd6960dae02706f5dd"
    sha256 cellar: :any,                 arm64_sequoia: "085bbcd7f83768fc081cdc3b904458e522fd36ddf56001d2bafa6d4b3ec1f6cc"
    sha256 cellar: :any,                 arm64_sonoma:  "30ad6f28614cbd0dae7b88514a063001032b89d3a41070f234ec35e3fe542681"
    sha256 cellar: :any,                 sonoma:        "88a55c18434ae6addf1e062fd984cd975bfb45373276ace009e9fa67e7d016cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd15855db96e3b61835d2e6843ea9b4defb3c13335035d74cca05f58ef76d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15ba997b97d0bb11ff3c1fecef9184541ecc4b3e75e1978a242e4065ad47da3a"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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
