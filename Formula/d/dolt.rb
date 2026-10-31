class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "2f63c25e49b14376b16e600b0d0a14704ede33489544990bff9546e591e24a5a"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2cf216a7ed4179c700592e396b74867790df099ffe88b6283ab7430728e7b17c"
    sha256 cellar: :any, arm64_tahoe:       "ec60d0dec0d948158a2538a723a6fc7497bc77cc8ea9a504eab18f82c8f8fc48"
    sha256 cellar: :any, arm64_sequoia:     "47bfbe457531448a3bf0a9e8fb826aaf4f3cea54e940098438fadea4d2b9b4bf"
    sha256 cellar: :any, arm64_linux:       "f9903767cbeedae3495813a595913faeaf2062627c53c3ff922efb9ea499037c"
    sha256 cellar: :any, x86_64_linux:      "f090a7b3a5ea03df8754b94503562af8864b43e892d857198022d3dca5149491"
  end

  depends_on "go" => :build
  depends_on "icu4c@79"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

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
