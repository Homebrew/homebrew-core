class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "9eb61d5bcba5524cca5c7e466a6440c483313f0892ce2e47d14bee0f2b4e0857"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc6ae92b0c3603523c02976e9e7efa49781909e40cef33f7a9044d0ec8977b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8593268829046829b677ed25a034ffb8a91c393708b1ba9a3df61784611dd8da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57fe15a8c1da891e59b7ea4048af916315ef5b254a837fabfff1479ad31bcd84"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1546081b64522261c82c381984b577f2bab5e42138cc110cf437bc3cd0a1cbf"
    sha256 cellar: :any_skip_relocation, ventura:       "44a75cdbe3bee8dba21a9dff22218d3fbd35773472358f70798959acfab2d0a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c504b601c449295427cf8a2b50afbd65c8a2c85a742049c17fb068578236d744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821e2c07e8d302b7a3ed9d4697bc55c30c5b3e5de2ba1b07fd64c2d7d504908e"
  end

  depends_on "go" => :build

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
