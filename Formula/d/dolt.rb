class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "5b0a8576c229e13e245dd7e19e76722dfa3a776e997a4c594943d1728cf302be"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6b67ff4edfc53a2b2f7a709a89009fba0edc6bd7635043351169d4c12c6a2513"
    sha256 cellar: :any, arm64_sequoia: "6d1a69edb9027836dca104aacb475ce1870ac4f070a1843b0a077e267cc70347"
    sha256 cellar: :any, arm64_sonoma:  "dee8864791910053d4b97f2618def7bdcf98906b9bb4d311c278d2c7e850cfd1"
    sha256 cellar: :any, sonoma:        "d370ef4bece5b9ac6f4b23b513c01962beae2080634a77b5f29ffcb72758a354"
    sha256 cellar: :any, arm64_linux:   "a63511a7dbcc75379fe8c773132f546cc716b1f5b8f08cb620ffff4483ed4034"
    sha256 cellar: :any, x86_64_linux:  "d3cc9a06ef2b66b60e123d789a3c10804b20e149fd4371c1d04f62a8c379a9ff"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

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
