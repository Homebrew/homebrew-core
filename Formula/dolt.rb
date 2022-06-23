class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.11.tar.gz"
  sha256 "b145e7fcc9abb8d4ce71339da2f163c5922ea387de5bb1a98c31f61902fab786"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8723c5b163ecff840f28847902cc5fe123682bdf054eb489fff962994db690d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "936409dd349421c9ae1877cec70f32a91c45679b0fd8c84f9872dece50d89d7b"
    sha256 cellar: :any_skip_relocation, monterey:       "3c91bb91b0bcef6833184636cb39fdbaef4251fa1be632069ec122a8e1571fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3efc576aa0b2809bb9d88fcfd9c0ab8792e5717e8166030a8e8f0c3915b9765"
    sha256 cellar: :any_skip_relocation, catalina:       "6d18559ec884f618e7a920495f8562014655bdd26b66c00a0579febf4cdaacad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217f0f779ffabfb0c9ba9636da86495c31d358ae2b9bd64f197f8813a0bafdda"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
