class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.51.3.tar.gz"
  sha256 "98b768dd79e08168680b69c8422fbb06c949ebee1b4d885c537c8d3eaaee2e11"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4851a3138925fdcd52df5c3746bdd213879f363646ed56fc20e77daab8997496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4edd91b7576d59cc6da9a9ca3ea49144791a5137a5d174e5753c3d16bb6740f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7246de8d3c1139df7eef3c09d7f9c41f94e3fb3c7b95a42af9c869e08fc201ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "95fc15a03ca5048df599fef1f7a4c74b81a2fafa52690df4142c885a7a0d82e9"
    sha256 cellar: :any_skip_relocation, ventura:       "f4bb7db9baf370a8e479e76d776e662fe631c253fe6ec12a4efdf924476ef305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1228e4500d9e66edf6916fe20cb9fa55968d067cd50174a11b8a1e825f754ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d4f61cbb6c72305c553fa2c5cf7d30afcb22b7f96de670ebf3eefee298ceba"
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
