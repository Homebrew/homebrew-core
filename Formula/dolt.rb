class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.9.tar.gz"
  sha256 "352a10471efbffb7f930f326765b6f5266ff46474e094c1445ef7fa2b6474f0f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589638d0d8bb92d97734fe0252cfca339aefddb040b0fb5231b29c6d5629fe06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b32a64c988581dcc3b2cc2e1a573d0ecdde9b9bf6b3c6dce61cd262da5fe6044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d58d59e3e9d6557fc0297b1e4888043c6f2b8cd2cf87eac8026afcab066ee4"
    sha256 cellar: :any_skip_relocation, ventura:        "85f910d3309a0f1d56629b8ad364cd12dcc5e52734786893c8e6f8b47213e2b0"
    sha256 cellar: :any_skip_relocation, monterey:       "6e34ff281d2b12becb0b7daf4ae64a8f53dbf9f978ea8c50ce2b55dc866116ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "db07b08670d7195d7456b03b3b8373d25faf8f4c330bcdfea69f7c0a07616b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "629f01546a66f0458426fb8ae355e0842d70e234170871cd5c97fa9ff5afbbf4"
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
