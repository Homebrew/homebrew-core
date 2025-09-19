class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.12.tar.gz"
  sha256 "b376894ffae3517ff32df9284b58570caf4bec9c960e0ec0b1b95e9c130a1b08"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c773665f0d1e83cd6b4860eaa1e5439af1178cc491d6ffd4cd8193531f552eb5"
    sha256 cellar: :any,                 arm64_sequoia: "a8be747b851dd102336881b2438a5847a1daf66113eca45a84ee31323a5e4941"
    sha256 cellar: :any,                 arm64_sonoma:  "dd89145e3d9334e6155a20cd96c16995026933d7f4469c658bbf7152440f7ce2"
    sha256 cellar: :any,                 sonoma:        "b1447d1f17fb67053e7f961864770df05198aefa5a07ed5d4cbcd54b549f7cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2830e8e8443ca609df5c4d78120bbca769d14885c6dfe4ddfa8076453e0aaa1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfb309d73833eb4d16bff0c05065022efabb3c481191c9b4fdcacd35cbc6b08"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

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
