class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.86.1.tar.gz"
  sha256 "760d0b4004abb299b325665ee280537184dc31a897ce201931ca16c6cb2790b5"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a350011aefee06d04ce46c3a483c7319a460b474ff213f754f1f0de00eafd2d5"
    sha256 cellar: :any,                 arm64_sequoia: "316cf3a0c749ac93533658a0b67192a003141f3135dc5ca37fa1e9a157a6ef5d"
    sha256 cellar: :any,                 arm64_sonoma:  "74c8841c431747a313fb392326e6ab9443b661c6dcc5219095dcf3bb246512b4"
    sha256 cellar: :any,                 sonoma:        "5938d11bbeeb54644934bc818fac72301270c2b6b076ae6a0341ad1ac68cb741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ddbe59768bc15e1773d52dbdda448793d088bc6d0e97eb862a8ad4a94d45d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c2631142ad11394485dc3bf91108abfd1bac70e35131b1c03064f89d2ec50e"
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
