class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "b356237e92ff546e252356fc898682df6baf2e01366d195783e656e78930c4de"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "236b54ee3e53df9ab1a96f52de49f9949edea3cedf39058f93ea7849e9bc445d"
    sha256 cellar: :any, arm64_sequoia: "593d64d7549634b2036b123b6887d96fb5b522630c53ff22f1fed2999313b18f"
    sha256 cellar: :any, arm64_sonoma:  "51e55d75ad9c02459c4807101019fd79f3da8401dc2e3149196984b8e09f6d45"
    sha256 cellar: :any, sonoma:        "615504e7776c3b4c8d956ee67ad3ba6c243985a2b13a1f6bd5ea75c087c400f5"
    sha256 cellar: :any, arm64_linux:   "9f47b3472563e314396aa8609aa6ebc2c9d422532b8eaf605881df2666352dc2"
    sha256 cellar: :any, x86_64_linux:  "d19d3aff4beaa29b6080429c6526f5e2f04f9f7845e7ccb259be1ff3ce53fcc1"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

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
