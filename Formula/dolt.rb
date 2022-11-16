class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.2.tar.gz"
  sha256 "bdf39321adaa0b6b746a65195c155e3e3238146547f6a220bf0bf2101e101ed8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ba37488ef420f7ba2112402800ceba1607c236e8d77ec1809b468d0c96775f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd870cbca907783870e77bab65dbe10bf15aebd3c48abf64f27ed34a2ce6a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f7e51e4303b0de635b4654f4c9a54033d2377def88bf717fae2f1882c83009e"
    sha256 cellar: :any_skip_relocation, monterey:       "5ccb1365ce8ae774f3964f67b5bcf5bf7240bbaf0f4f5acf9b367ea05fabc88a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b285a7b9e0c9ef4bca609c191047ebb25697b896d4bc6c0beae7b609de14ba60"
    sha256 cellar: :any_skip_relocation, catalina:       "5771240e7ef275750f2e7263175f5d4bceac411a358645a6abdc68a9a0d31c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31258dc189c330b9c30fc9c79366ef4ccccd664a47c17c4b539cfb066327c2b9"
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
