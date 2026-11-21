class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.6.tar.gz"
  sha256 "34916339bba65bab6ff57bc47182f1213bbf64ee507b59c8ef1040e22a5143b8"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7ba9351cd6789bd4c645107bdcd79950fbcca5ffbf3570d4f2b856b12e72c20f"
    sha256 cellar: :any, arm64_tahoe:       "9edd88874e4023fa34d7df60496363e2e413718aa382b79df301f3dc9ad6294f"
    sha256 cellar: :any, arm64_sequoia:     "3812d6758a55d394d3faed00c6815ec5d61820c3bb8dde0ab0dd4b924756c8d4"
    sha256 cellar: :any, arm64_linux:       "4d81126aabdb03c79eb913bdc623dd92e1fe6cab991f32d4d76417dc858695b0"
    sha256 cellar: :any, x86_64_linux:      "b8adb1505642d36bd618bd16af76650ddb98e4347c8d705d9dea09ed0c54c51b"
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
