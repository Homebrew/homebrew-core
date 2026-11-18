class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.5.tar.gz"
  sha256 "7fd65e60d5f1c3a47513f03a28b101ed694ea5b02871a569aa9526ebe6e25630"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cbfa2c8e3e5a199c82c5e886122050c4824a5ea37c263e8df6ffd1c02f787d70"
    sha256 cellar: :any, arm64_tahoe:       "97bba790aedfe62deaf14321fdcd93e34b87eb51d905222e7d5c25d825ce2ee3"
    sha256 cellar: :any, arm64_sequoia:     "98e887e008a7bc90b849112a7bddfd85e75a002be9b5019f496ad7f8f54f299a"
    sha256 cellar: :any, arm64_linux:       "828276d7f523f91457e22e9e3b575878980b18c1c77d37c76359765ed397120b"
    sha256 cellar: :any, x86_64_linux:      "f194826e937b3bcb857f603593c91d39e29b330611895405017040cfc0e97b3b"
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
