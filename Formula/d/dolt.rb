class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.76.4.tar.gz"
  sha256 "23b7010a40f2d680c3ac337d5ff80c0c70dd23bd912eddda6e3135d7a93c816a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a5e1780e0ffb49442798a88d4d8687e3751209ff649daede02acc6b00be8d97"
    sha256 cellar: :any,                 arm64_sequoia: "de96e4398ab81554a45bf848b842d7024232e1da71c561666ecd447a3e310c01"
    sha256 cellar: :any,                 arm64_sonoma:  "678c1f13b42886786e1374c7ba0f31d4cc3d2cf83e183abe3191b8cd376c96d4"
    sha256 cellar: :any,                 sonoma:        "f1c31ec200f6c374837eaffec7354730f805155bb7e007c8e205dd786e2a545d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14039828c8596add5c0cfa8882870ef6ef141b8ab79eb9dd8b5145f91639343f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a623922065daeb586cfe34366e3a08d239b5bad031a89ba95feef1ba65c04ccc"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    ENV["CGO_ENABLED"] = "1"

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
