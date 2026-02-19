class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.82.2.tar.gz"
  sha256 "8378025b8a3e0a17eb321bc43e2d219bf5a6b1dc6ab88dc9167380a3d41a89ad"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46d1a119782b9c90ce7e2adf07f662ea818bc539a28d9a9f7e6c954867af7f51"
    sha256 cellar: :any,                 arm64_sequoia: "b31d62a2c2399ee6f4ac14dc0a5b8accab48f6f76f1b127ea3f28901fcbff17d"
    sha256 cellar: :any,                 arm64_sonoma:  "1746545d64d7d177f75e1378184bf5b576554407bdcdf5e7ee40002e34df20fb"
    sha256 cellar: :any,                 sonoma:        "b88b970427fd2084c2d0eabdc62ceb749144907962200a12bc1ad7e66556ebd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e32b04aae612ac6fc831e73bdcd6e146e354ce182db4ea22d459271e71b37ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef0c6283d73acf20d3045c1959629e50088c6bf909ad690d5071f6fdb79a6db"
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
