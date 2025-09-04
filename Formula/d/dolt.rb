class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.2.tar.gz"
  sha256 "653f07b42d9433a4fdb4bc72babb76514066782696f1c5bf68bbf6e126839ca4"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c93db2e90ea59dff898f9058140a7ee80d33fb4ebf6e8359dd57b4076ab29c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a74914a389bbe17e5b2793812f1a0101240dc802a091fdf376055ec0f55d87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0f8fb964153071390e1d18daa685b5233c76355866db0261cfce78058f4c8f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb74dcceff6fe4ec98e3e5d98c2cfe92a96454c77610563f82e9a98c74737c03"
    sha256 cellar: :any_skip_relocation, ventura:       "bbee8e6f009cf815830b7f248503a46614000234fbfff90700c79c581a56325c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4cd6bbdd34d1d92d15a56ae11a6b7fb49e31da5758ba77904a2f2d061d252d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680d1f72e71c44cd5c28d607532d2a149f1de8a21758a85e6466e79400141156"
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
