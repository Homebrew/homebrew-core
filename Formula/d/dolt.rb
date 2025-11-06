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
    sha256 cellar: :any,                 arm64_tahoe:   "bcea7dc5339ea087a850533dedcfcd3043d3aa2c5b8cdd9ffea6487ecc6e6ad8"
    sha256 cellar: :any,                 arm64_sequoia: "ffec09baf3d4f0141e1838d11d4f1323658afd3d5f7a8b170de0a3aabb1366a0"
    sha256 cellar: :any,                 arm64_sonoma:  "7591e5de1d0ca332e4e1f529c628a9df77392a95a01e391c82dba8e8bccafe2c"
    sha256 cellar: :any,                 sonoma:        "fb28c472d6d019cf910bc9a836ce8c0745c4789219f1c459ca8ee56b4044e616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23061f02d4937cd2b6015c4a89bc1bc4549071c85e7129272f9d5cec2eb19373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ab6e1b51c243d1f989b1f0527adbc28fbb629e8a2aa745dc44abfee6cd6455"
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
