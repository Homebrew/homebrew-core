class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "de9d03fb83c32cd428b7d5df8cb6bdcfb1620d6bf4732369e67bd3ad6bb102a7"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "625bb8305eb88f681e133f4b5a5a62a1576b8197a545eb4a8c98d4811abfbcc2"
    sha256 cellar: :any, arm64_tahoe:       "5aed8682f146622f58c9030bf8ab609959b4da71cb140a8396a37294fcef9f15"
    sha256 cellar: :any, arm64_sequoia:     "152e14d72215f0b00fa412fa37b6a2030644fb362ecef356106c396ab481325b"
    sha256 cellar: :any, arm64_linux:       "acdb3be9d1959d32684ce8234f6495df12244be9d82b3e93b494922ad8549f2d"
    sha256 cellar: :any, x86_64_linux:      "2c22f289c8e88501ff8e65431beeb1f27462932646ff0f0c7bfd33c391b8235a"
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
