class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "6a4a644fc78142b90c33db63d150c3c0b13f6d08ee9738040cfd88364195aae6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2376d3c419303a5d42464f530d93b1bb59c951d04befda659de5b80ff0da839c"
    sha256 cellar: :any,                 arm64_sequoia: "f551cb2abe6bcd992dab3807a1bb0ba6344f0c0a0fec91744569cdcc230686ab"
    sha256 cellar: :any,                 arm64_sonoma:  "82f9235693542eb0efc4c2a7ac95def6ec771cf10508b66d2d87a1c72bf1feb6"
    sha256 cellar: :any,                 sonoma:        "c185c636a66951224f88a1df0ec851f84d6946ffac796aa99e13b45a1c5a2146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe94b0586e8f3449277f6804a6873806acccf2185b09e88959b6293805daa57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef11aae1ef0bf7a13b6540c0109a61345a754230ae95a18266ee552d9d089df"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
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
