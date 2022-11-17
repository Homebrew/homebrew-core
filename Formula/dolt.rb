class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.3.tar.gz"
  sha256 "ad30b92dd386ce0cda2db728bfb8b5f375ce7b6a4c65bf8ac0f7e5b69bce040c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf93ca3c91e748687884c713d07ca02dfa95e0582925ad13ccb9c4779a825bfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09e4f4408a0cbc0b0b1a799b440b4a525425261bf8597965985e0a4a8ce866e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c98d1e3ad7e0752fe3a3398cd97ccfb55d480f0e12a0de70e68f6e3a56232261"
    sha256 cellar: :any_skip_relocation, monterey:       "20e2cedc5e634dac7d18874c07b2314710edb16dc77841f6ba7fc57a6848a2c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b11cad5ae3c634467e96281e734ab66d53fd8330465b0d51ebfbc3282faac63"
    sha256 cellar: :any_skip_relocation, catalina:       "b7a3388876f2ff4ef4e60ab3437530849efdc20a4a2d4ba2e6e41daf0976e96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d015fc0702a8ad54423689bab3a56edbda7eebef396917a09e65f534994f16eb"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
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
