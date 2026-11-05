class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "52589122468ca9510b38b44670569ac34df9df8a8b600adb8beeb7bf493249d1"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "037bb62b0058a2a070db316a807949873ad7584dde1b0c0fb360512f820689a1"
    sha256 cellar: :any, arm64_tahoe:       "22926129948007b8eba4b2552c976ef8e63ef6367957a084deaa759f038b5495"
    sha256 cellar: :any, arm64_sequoia:     "8da49ccefcc6ae9cf87af1722db9487aa6e67fd92cbfaa84cc34cb64fd6c2aea"
    sha256 cellar: :any, arm64_linux:       "54adc33d5176d4aa62ae1f1d90fb1f5f85e219a520b8cd7807b3568f3b3c540e"
    sha256 cellar: :any, x86_64_linux:      "4228c5503cec5262b081e582b1ea7a4c89a6eaae170079937d150ddfbadc7bcb"
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
