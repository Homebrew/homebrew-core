class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.4.tar.gz"
  sha256 "abed2585a39a0f341a207fe2a67f847a6ac438490f9dc310717bc9877ea6b95d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a2676b39e758267248d663b730d6edd573417e9d56ace829bcc28a364da492c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f6c9fc12fe925d7234405855197488a6c97d7a72d7fbae10a63d61e035248d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b99a172d34a21b89e803870c7f6d9c796196b5ce61c9b4b341c06b049b699d51"
    sha256 cellar: :any_skip_relocation, ventura:        "3403c39093430ebf83be44eff18f7041b8d997ea07bd4502cb846d453a3f6019"
    sha256 cellar: :any_skip_relocation, monterey:       "a8301b065f3bf1875bfddba50c38a134a72b6d14ce33b6c8096399b494aefe5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "526d38af8d0cc8a8e3cbcd24348f80f074baac5da1411a7d55a59ad410f3cb2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "569a078497fbf2a11ef9a42486a42eda619f8679632bf032ea81bd2105a8fd9b"
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
