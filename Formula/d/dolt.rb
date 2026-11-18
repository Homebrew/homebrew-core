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
    sha256 cellar: :any, arm64_golden_gate: "ec4b0a57b94b4c55d1e4e496b8f45000bca78e83193f3b181acbb4ba70cb9d92"
    sha256 cellar: :any, arm64_tahoe:       "b79e0c04cecbd0e49faf8ccf934753c69df751129ddb52a6c7460fad72fd898c"
    sha256 cellar: :any, arm64_sequoia:     "3128c76123be05434a4411a7219a35eef63739250f8a0a879cf8972739882d65"
    sha256 cellar: :any, arm64_linux:       "f09a1670c66b40cbaa4bf28b76dac56a76451615cf43b1e6997a4d2c263d30c1"
    sha256 cellar: :any, x86_64_linux:      "05cb62ca28457ba72eab7b6f548b9f67f449a646e247ebd2f5134211caa80476"
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
