class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.53.2.tar.gz"
  sha256 "18f3c1868181484de8939b833358d6bd09570e24db7a6dcfd3dc09bdff41eb72"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b678b59c63b0d8e741473492920a8cf6b6f2ce41948a2420625595dd960d72a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b678b59c63b0d8e741473492920a8cf6b6f2ce41948a2420625595dd960d72a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b678b59c63b0d8e741473492920a8cf6b6f2ce41948a2420625595dd960d72a9"
    sha256 cellar: :any_skip_relocation, ventura:        "6a196c32d48974c833122fbc98c3d61f0d45de902033396f661a4caa7b410832"
    sha256 cellar: :any_skip_relocation, monterey:       "6a196c32d48974c833122fbc98c3d61f0d45de902033396f661a4caa7b410832"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a196c32d48974c833122fbc98c3d61f0d45de902033396f661a4caa7b410832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6800c73d08a33a9f790094987a1aa57a3a82f34358991bf13001b47965b1b49"
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
