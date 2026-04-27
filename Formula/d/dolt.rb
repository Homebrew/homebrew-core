class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.86.5.tar.gz"
  sha256 "ff0e7629e4f0a97c6926f54e56dae1b098881e6bdf4ecff1b730c9dd4c63b74d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "464d6ac8e4a8cece315bbe99fb7ef746b7fa7671afb72da6b6ba48b509475684"
    sha256 cellar: :any,                 arm64_sequoia: "c6d4967483289311346a648c1f46b738258c8d703b72270ed991f1a5dee91716"
    sha256 cellar: :any,                 arm64_sonoma:  "9267cc4910325d22fc32691e341f15598fd74de0ea78cf4c70f90cf728bf36e9"
    sha256 cellar: :any,                 sonoma:        "1463ed5271f76873c51b92598efb900444f45608831b079c43d8082bc25d63d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75876d993a03082be0924eb118da37438eba0e3163169292d1847893b2c69589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec5c21968e08110bf19aef45593311b38336ed4ab1ef86dc82e291dcf1576be"
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
