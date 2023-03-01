class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.54.0.tar.gz"
  sha256 "fc03277653fffaa956ed478cd07d50715339724503f5d1d62ddfe116a019d6c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d69a455e6975aff958ad132767634f915fa1b177da07dda074257de39ff4668e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d69a455e6975aff958ad132767634f915fa1b177da07dda074257de39ff4668e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d69a455e6975aff958ad132767634f915fa1b177da07dda074257de39ff4668e"
    sha256 cellar: :any_skip_relocation, ventura:        "7c365d8037b4d0ddfefb93c38c1efbdab13537b191d9de3ae0a0ef2b9cb0f747"
    sha256 cellar: :any_skip_relocation, monterey:       "7c365d8037b4d0ddfefb93c38c1efbdab13537b191d9de3ae0a0ef2b9cb0f747"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c365d8037b4d0ddfefb93c38c1efbdab13537b191d9de3ae0a0ef2b9cb0f747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64957760d95d12fecd8ae52b492b9b6e585ff1896017509cce33afe99c51408f"
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
