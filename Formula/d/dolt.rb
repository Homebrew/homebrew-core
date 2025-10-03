class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.16.tar.gz"
  sha256 "ec23ab09124f265f76f91d5d0c05eb981be1976712704079838269f1e610ea6b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb4da2c45af94b27243748ff91fdca43b3aaaf4d1e5b8e2a981ef8758a2b312e"
    sha256 cellar: :any,                 arm64_sequoia: "8dd6b59626fbd377833d964dc4063c1e869712fac94ed6cd548791f8d4321f2a"
    sha256 cellar: :any,                 arm64_sonoma:  "342aa307242e9af535a7a53548828f10aef1aae87181defe6ce2a977169b44d2"
    sha256 cellar: :any,                 sonoma:        "72ca1008d03bfd19cc9cbf3a5aa15032a2398b9243f5bdca28d3ebdc60259bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2e1eb38fbc82648980cf5fe4e0e0a56f464debf8c4484f049e698e28b5739e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701f7e8fc99274baeecf9bc01b21569c4969a3e25e44c1bbbce428f660cf196d"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
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
