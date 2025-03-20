class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.50.9.tar.gz"
  sha256 "b28401dc364577de54d361864ce738143da0faf6a4db2811666b24c84413ad37"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bfe94020846a9df66e4670be4f16fc0958a089cf331cfd9a7db854cc687de3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9079495162dfa4d5bc32dbce07c806b9997131b2c32540217f08c81903b4dae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10b0b42bfb9dec62fecfc00e0300afe3197db5f87dd209916406a39413186c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "616d575f53915772324ccf7320a6598e119c67539e2e6e7f32951d709fe94250"
    sha256 cellar: :any_skip_relocation, ventura:       "7411a2db9ec1d4dfa56b57917b0e84609bbbf8ebc5d6abc0b11f6139dcd95a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa08275c39350841b068753b16a81c5b2541d7a0e95e0a851b069e3008b5c85"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def logdir
    var/"log"
  end

  def datadir
    var/"dolt"
  end

  def post_install
    logdir.mkpath
    datadir.mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path f.logdir/"dolt.log"
    error_log_path f.logdir/"dolt.error.log"
    working_dir f.datadir
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
