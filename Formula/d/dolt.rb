class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "7ce69e1adcb6d9929dda6e5bdebb562afeec9620f91dda52a755d9cd3553407b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b3614296be89e5676cf7628cafec540af965bdc078a41089541159225a0bc97"
    sha256 cellar: :any,                 arm64_sequoia: "6c913e7177d6c986c1d3e70dd1dfcec27a88c73883f3439abc47000ded37c4bb"
    sha256 cellar: :any,                 arm64_sonoma:  "880f41728b98d06094ad478728a7f7b148c7f32be8ee5695997f7e8ab5bded28"
    sha256 cellar: :any,                 sonoma:        "5d04895473b4522bc6665e631729c339bad12f975c60155c41b2a0a2e5e4ad16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5603a70e6c74262636c0f5c32823b2462548d88079d5fc61b1dbc9cc284ef36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a2a56017509e279177f85fa3c740aa334bdf283fe2c60ee4d16222a9278b162"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
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
