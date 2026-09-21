class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "30b0d853c87a1c7c2a1959b448fd41dadc1c0f4d2c458ebd22893a5fc68bda27"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff9c48a43c433486665fb658389121e7a552cc46a7261544317029e15234fc88"
    sha256 cellar: :any, arm64_tahoe:       "e6843694ad4d773bcc9f1a969602c8367b7348e8523ca6bc2094c3b001e9895b"
    sha256 cellar: :any, arm64_sequoia:     "2ba7e0f7ee7a87c3c537e7b4d2328a7db400a35a24a9535a54acb4f534f31569"
    sha256 cellar: :any, arm64_linux:       "516c4a55ff22af9a2128855bee5d5b873349efd724b20eff333cec703f87ed32"
    sha256 cellar: :any, x86_64_linux:      "ba81454c2ade2b5579edfba5ccfb6d2f863be96df27799c103741eb5b09f93a6"
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
