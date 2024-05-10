class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "367b9cf0771058eee4fdd85607279a2832dfb7563a67134dac9254ab6965cde8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caaa66b2a92c087a4fb28d381889c587916336ca4d13c572f374ce4d284a8095"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a278241b6444284ff85cc18c99d9554952d7aea6990a7928106c0fbb4263614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5936815573fec90c9a96575e7998733cd2d3b0df63015f32a4b1a7b5bdd534f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee5a6843dba20e6323fb508c2c9fca99a3f074d5f9e213a2a699cb18ebe9e6e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c071191d1d58377a5a66c78b19345042000b7ec1935435a2a7b5ccff6a3ec1"
    sha256 cellar: :any_skip_relocation, monterey:       "cdec69380b97c4174df2ec01a68d3f6d537d3374d85337da0b10a46fc4136497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0aa94940a4c27768f3457587454b5d2d5a1e95531dd180af73377eda792df37"
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
