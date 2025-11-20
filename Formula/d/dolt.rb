class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.78.1.tar.gz"
  sha256 "e4b8b138873a02def654bb374ca11ec63de8d6e8ccfb0286d0aaaaa62c9a7356"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60eff6247ef4f355b72869fb1b6e0b8888861864f743820031c9500f81cdcea7"
    sha256 cellar: :any,                 arm64_sequoia: "62af7675b98066efe608f5b97834c70371355f10b6ed4f4b70a9fc3a07c927f7"
    sha256 cellar: :any,                 arm64_sonoma:  "594046f47ddc10c3d4c083affbd7d1f651b7feeb644548863bed2d58e5d6f2d1"
    sha256 cellar: :any,                 sonoma:        "2139fc1cd05599f2f15d99d544e6494f891256551e0b37277deac1ab9e8ebc5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94cdfb867685fc769e38b3e5727a039694a1080fcd8dfcc79210297351abb643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f804a4ce30def8d8f62faf2df2a97d617be7719e0e0d6a635f8e30e7cb49e4"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
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
