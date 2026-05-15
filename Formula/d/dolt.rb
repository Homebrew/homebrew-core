class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "c52854f5cdd94902b942efaad37f8d0559426eb968c5cd8a63e789c84a965699"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c482a13a5872e31e4dbd298add9fbc0eed7ed10af7e1a33f609fb3ce094fa1b"
    sha256 cellar: :any,                 arm64_sequoia: "18ab15fb9207fc00fda969c3ece10a8c236be43912913fc8dee36b053ad2d204"
    sha256 cellar: :any,                 arm64_sonoma:  "8cc11dd3ce6b4cb0ae143bad47c18d213dc3ede4e2cb107ea2d1f29288b6a61b"
    sha256 cellar: :any,                 sonoma:        "9be81eb39f975e3c6e56c22f4421070d7898a0a6804c3a474f6cd841fb3b73dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fb0969ac0228f6a1fcf2053c259b588cf6cb8e7971f1dc83984615c97034799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68b51c7be1f8d65e3588b78403aa43530c6bfa6e686852a8fce830506174aac"
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
