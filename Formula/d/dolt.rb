class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "c5d738a6c1502341b65db5cb19e1bc5ea6e2afffd3a0ea3217497d3d33e7f4ac"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a31e987ccd7bd9983f6f93458b910129f0faf41ffcc61cdc30bc13697215474"
    sha256 cellar: :any,                 arm64_sequoia: "b2ce2a56b4413ae330da58a79d2d7cb467d035db0cefa5e8ba5af91e62bf178b"
    sha256 cellar: :any,                 arm64_sonoma:  "86936a9d45014a2d61a30b1208cec66719edd4e348bf3d8e8da63dcbef5736aa"
    sha256 cellar: :any,                 sonoma:        "a8c97fe89b4113d2ce945a2d214c382ee9103f5326a1af3c25dcd93468f27769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b92762059773f7603136dc23fc0c0dc3d7678ec66ed7116fddb13445a010a1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2d918863c8e9545379ae2c4bb989c6aeadf78eddff65b3889b44277aabdcb8"
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
