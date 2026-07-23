class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "b575075f601ebb6f929896ac217b09b7303c9e9274a4cc4edcfa543884bf1663"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6fb28ac3a87f20a7cd32f0f99765adba971fe3263a06a35d81b500f196f762fe"
    sha256 cellar: :any, arm64_sequoia: "efe0fd0dfd83309168696fc4c8a0ef3f26ac0c4f72fd35f876ff498fa9d2bcfe"
    sha256 cellar: :any, arm64_sonoma:  "54e5f6ca2ef509ee20b136c890ed7b7bbe6b4d914eb8d4aaddeb37e7083ea74b"
    sha256 cellar: :any, sonoma:        "0c9bdc9ca68c4c33a535cbd4c28cde2bb8e2a5424ad30cb8c8378ab064c75d6d"
    sha256 cellar: :any, arm64_linux:   "d18a63a944a4564278d797645056f65921a4300f15692f5f9b6cc91556ed1516"
    sha256 cellar: :any, x86_64_linux:  "f9f5cf9184e51a5d898b078c3d0df4a4adf6531131763e125ffd3f3f7be3f5d6"
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
