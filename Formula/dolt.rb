class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.4.0.tar.gz"
  sha256 "ff537e1660cfd70fedd268c1055ffd8fa2e0ab45abaf04c5737c7a00b56aadde"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c59925064154774433faa9477dd7c1c19b0b1f82fa97cfbc7b42b363d37f7da4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c59925064154774433faa9477dd7c1c19b0b1f82fa97cfbc7b42b363d37f7da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c59925064154774433faa9477dd7c1c19b0b1f82fa97cfbc7b42b363d37f7da4"
    sha256 cellar: :any_skip_relocation, ventura:        "075807739faf95814b2d4a3a3ce5b8c41e525d2e2b65252cd4d92bbe4c5eb143"
    sha256 cellar: :any_skip_relocation, monterey:       "075807739faf95814b2d4a3a3ce5b8c41e525d2e2b65252cd4d92bbe4c5eb143"
    sha256 cellar: :any_skip_relocation, big_sur:        "075807739faf95814b2d4a3a3ce5b8c41e525d2e2b65252cd4d92bbe4c5eb143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b482014b11d207a4c4313150f7a8277c2e4b02142202a473c23338d2da5e65d0"
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
