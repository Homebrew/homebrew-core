class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.13.tar.gz"
  sha256 "48ba2827fde38a8794ac900d4b30aec3a97a1449cc3109523df2568b3ad4c178"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0cef114c08f9cebc9f5326ecac596fd851fc38c0d56d9b636c055c2b757929f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0e75b5c2e63d56cb72cb5d273638c52d85c01f814a5c7002aba599ad5a56a38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47635e4307f61b46e53932d3773aa5cc204d153e567b3895767dc5606f2f548d"
    sha256 cellar: :any_skip_relocation, ventura:        "dd0c585b1674fd579960e4c453b2868aa05c0633a8165ad74c62f90f9a3bda96"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5a185b2ecc999607eda1dcf1920bbecfbf26b1e6a20559a32b9fe52df7c42d"
    sha256 cellar: :any_skip_relocation, big_sur:        "56a0a59c57c59e8684866aa26f38f99026fc614655169dc6cd497812026a7db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77e404d21df2b55e03b8e3c756b35d58e8c7a021829131ed13f179f9cce4d19d"
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
