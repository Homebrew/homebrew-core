class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "1e4fa8fbe7ef443346e47ea843afa2e6e4698cd8e5f8f73f276ea606932b6bea"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4e1f7718dd4fa64468e010f82201a5c6c1d4b13130b61be21300b3d36001f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f8f9280a2ad1b4f9a1674907244210193f93fdd7e3b6b8a831c9b13cc73cccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b87d55cf3d84fd06acd1d8c08a529598a637a1aab03c86ff40351ff6472deb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbb9dd1928beca15403daed7f206d71ba88e6fdb0e20752bc026362a0225a7e"
    sha256 cellar: :any_skip_relocation, ventura:       "232bc30389b7f50a64b8d0a39d8b22fd89e891459124cb7bacc5db0858747540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf22c17607d50d3c2f681f34be72df76ce563aec3d442644735416201647cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58392b77ea662a2ae09bbd7bc5a2cf2f073c77ae2a372b34a41bb787bba560c6"
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
