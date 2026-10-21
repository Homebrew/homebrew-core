class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "c9c750d80fa02043203e2f339885382fa298fedf7e2d76eaf5a3383b58d6dafa"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9334a7dd895eef22cd6f61aa38063bdf603c087576bf4481f3bcd6ae8cf18f7b"
    sha256 cellar: :any, arm64_tahoe:       "688e58bbb5a1349c44e14fc2aaf44022d684da7f769fe533ba572a3b1d6e83a2"
    sha256 cellar: :any, arm64_sequoia:     "5e444e7171d4acfb4b63a46bc9d1826f994959ff5aee82bab0e957cb88b12967"
    sha256 cellar: :any, arm64_linux:       "c3770464a2ce74125328f61edc7122c46555e0c5414b3b3cac67f10be144de32"
    sha256 cellar: :any, x86_64_linux:      "e322d02736ef0d3ea181cfeeeb4747412501b22e084c8ced08cdb2d824910348"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

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
