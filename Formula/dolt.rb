class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.3.tar.gz"
  sha256 "27078bd67faeea98ccda8334018b79a6f9d66942bb63e0542ed33f28294e84b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73e474f4a11b84a2b76b7e49b1f2b976fd4196fdd6d43f41954d04bd00669561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e474f4a11b84a2b76b7e49b1f2b976fd4196fdd6d43f41954d04bd00669561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73e474f4a11b84a2b76b7e49b1f2b976fd4196fdd6d43f41954d04bd00669561"
    sha256 cellar: :any_skip_relocation, ventura:        "54c89aaeb89f1d6db7a2d70805ee525be3b6b8a88a9e13e0a2386425966952ca"
    sha256 cellar: :any_skip_relocation, monterey:       "54c89aaeb89f1d6db7a2d70805ee525be3b6b8a88a9e13e0a2386425966952ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "54c89aaeb89f1d6db7a2d70805ee525be3b6b8a88a9e13e0a2386425966952ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "878515f6001acb2f83622b64875043748fd9006ada42ddc90fc6bef8c9741d77"
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
