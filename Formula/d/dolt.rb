class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.50.2.tar.gz"
  sha256 "e65156bd99dd58195ffa6c1ce12b12e46d45ef7a07f90f157880259243054c53"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4afb6d687b302b7cb04579827e7af58f68e166833325e033b260b3c42a5959ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33eeb5177fc1ac10d488ed28d69971429c1568c8d584b6dfa3978747b31ff73f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b928506f9513ac1561e858379fc8f03d4fe495ae11399cf85e709d0c4094316e"
    sha256 cellar: :any_skip_relocation, sonoma:        "085672aceb8f9b54a5a08becb49f70b84b1a3c87efb6204a6ddba6211d5d5e56"
    sha256 cellar: :any_skip_relocation, ventura:       "522c0874d6ffdfb100598bd7680ad0e84396f1dc4a2c0c6c0aa1b65d2515b90b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f30ef5fcbf9799cf3be5659f155a061ff4d5962299b71d75393fa0c79cd0b2"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
