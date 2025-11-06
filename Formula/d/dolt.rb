class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.76.5.tar.gz"
  sha256 "a6f0b38e97a20e7030ae39c18f02eace87bb21e9ea6bdbbe1cb8386eae16f0b2"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08b03724c174688e8ba88cdc2c4cf85778ad740a2354ef64cce4870ca3545962"
    sha256 cellar: :any,                 arm64_sequoia: "13fe366ecf3e700cf39b3563e3e58d87b7e66fb9c2657b9f190d0f330f742d56"
    sha256 cellar: :any,                 arm64_sonoma:  "27d3fab894f4e0e586832978a645af5236c3a0e5731ba445255074e84a119e06"
    sha256 cellar: :any,                 sonoma:        "623fae7929a0aa3b36a6878ea20d2680afab54807ac9fcb356a32353838ad29a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c9dcfdba638266eb15ca52236b0ab1bbed39a8ba19fcd3a67926242ccf565d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae0a0d73700c29bbbeaf5ae40644d3196316f4f46c8b03335149c82dbe0a792"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

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
