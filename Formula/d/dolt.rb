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
    sha256 cellar: :any, arm64_golden_gate: "eed15b7702222a19b3865e8d74b5e9d244e35e5d0d7799fe257bf21fcf2ad9c9"
    sha256 cellar: :any, arm64_tahoe:       "94a76799c649f6824b94e275df8d95991819df02e200367e32335c8f1b610ca3"
    sha256 cellar: :any, arm64_sequoia:     "5dd3839a74e1c5df91966cc66e2d2d4424548a838616fd7504e0976a470a3306"
    sha256 cellar: :any, arm64_linux:       "369200a266d733170376de10bb131d03ad7757a64d2c9607e9bc01b12efa3696"
    sha256 cellar: :any, x86_64_linux:      "1b9c3c68d313a6334f4526063e1e03ac46866e9d180c877073f0d56647105e0e"
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
