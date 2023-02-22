class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.53.1.tar.gz"
  sha256 "fcc668c72d12d09f4abba3b419de2b283ecac1f5b4132e50a0957ac240a7a87f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba6ce73962eb0e83b91e68cff7abe28f462526ebeb5a256badfb7367a0b8f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92220037a084a0fc141d2e662cae1029d01a883db5b247ba4397daee7b14e6b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0e956fce5fe509a711457e5cca13d0a371ec983b617a8ef794711b73c011e1b"
    sha256 cellar: :any_skip_relocation, ventura:        "c9c4b81fa2cc8c37c417e5b0f5c89629d552d2e9b7a0d89fe3ec86639d4ef49b"
    sha256 cellar: :any_skip_relocation, monterey:       "4500c1db9453b12dc1252db6773b802c3a1e14d067af36d330f90c8cbafd60b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4fcf0000b41fe9d2316a259c66727dde56d2286b101b528586def06fa3a72b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ca95f3aa68ff1028cd37e4f51fb1d329460b721c2d8b8d4bcb495ad7c4335ee"
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
