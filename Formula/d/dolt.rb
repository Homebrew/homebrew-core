class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "44555e2e53482c93b331ff07b43d849dc9eb664288d6b6cb774abe83f1f96a44"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "664b83964cf7c0328666b6d47fa54b4da7993f2a4ae24355aa7f6535921c2f08"
    sha256 cellar: :any, arm64_tahoe:       "1a0035717971710e44de94f821e7ca0893a79251676983b54c2401524d4eae09"
    sha256 cellar: :any, arm64_sequoia:     "72374ef025007d2142cc392a98fbc1a4f5873e5b253c33109f54f70d04bd543f"
    sha256 cellar: :any, arm64_linux:       "cd007c7ecdd825e06edff1eab28dc300f61a1ac9736a7a239667506e64703d2e"
    sha256 cellar: :any, x86_64_linux:      "d9dcaff965b202eb798446b14b796013cbd98badb07b55c6f44b0b6468f0a2d2"
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
