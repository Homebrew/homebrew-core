class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.6.tar.gz"
  sha256 "b7acf1cd7071c3db7b832bcc7f4f014f3a7e8497e0e53cdef6a833cb7ff6a1d4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b6bcb97804bd93927a26650a6e57e5cf559c71b37b66b293bf84006068dfab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7dab721b1aa96eaf0a9857ab86e9d18687b54e4fbecf693a6cd806dacaa49e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd1cf45a95024a4628aafb51a42c9a21bfab142ac9cdb17975f106dc28dd99a0"
    sha256 cellar: :any_skip_relocation, ventura:        "24d2f851821f2cffbfb7e9d71824173782ddef90ca896cc84e553641b82ce3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "af9494e688c2790274fbb500be0b41cd596ac6f39a6f9a704fbfd0e087ed3dab"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa603163a963d17be578494dc469338030705eba57a2fb64566c48cc1a978ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f831e178421498d605b942bd08877e833e34ac404d0281735a82c1f36160c2"
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
