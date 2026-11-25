class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "134d66722b154252c017b4c223cfba02f2d9fbcbcbfd223a4a3d7552f3ff56f6"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "12b986b1fbc134ca905f6f91fadef5121750b007ebcf08e33f8e0986bcbfd895"
    sha256 cellar: :any, arm64_golden_gate: "8008c49f2733604483e2ff6207ee3c71a129ae7f552d05449ba4d4e78b6bf544"
    sha256 cellar: :any, arm64_tahoe:       "113f5826bd5d50a9d78b7c5fd46cdff3275b026b3b1fa77fe2dacdf910c81d33"
    sha256 cellar: :any, arm64_sequoia:     "c6296e7b0cce9d33de8e9f10a1b4d7f47b94eb4de4c1ab16521a99206d06ac54"
    sha256 cellar: :any, arm64_linux:       "20a45c7444332bd58c5de6dcb0fa9892da8ce0661155e31215000b68edaf6907"
    sha256 cellar: :any, x86_64_linux:      "fa14b57c968d6558cdc8f862da1dd84477b7de614cc00fda9b63a58cd0de6ce3"
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
