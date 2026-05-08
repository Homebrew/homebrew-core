class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2550c535da71267fd29597045f17fdad996ae2168c0df45162e93af92f4fa0e9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15efd23d3e9ea38edc94addcc7c00da59aac441ee380931cbcf3fa9c1a237210"
    sha256 cellar: :any,                 arm64_sequoia: "e67961347cc320be233cb3e162defd242791995f1aa8502303b7f57e7a01af56"
    sha256 cellar: :any,                 arm64_sonoma:  "1c0532732a8f6614f85b0e3c88fd3b52402a14c41a3aacf2fee93a9ea346c463"
    sha256 cellar: :any,                 sonoma:        "055ab2bf850f2c7b966c77b18bc513d37ddd20b4acfc7289c37ab4432ce0cdf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedfd3e482405c557ff4a8c54db549fc0b2a9e1cf9cbb7fa116cbc7c95cbd82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad22de07f94e7048d083efb72a68119e2f9651f100eb878a2b96fa860b8ae9d"
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
