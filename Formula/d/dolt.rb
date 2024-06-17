class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.40.2.tar.gz"
  sha256 "8fa6d89ad89bce05a72b5920e5edc1136a1c046330fbfa5d9b49c4ebdfd50e29"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f5e06137951e1cde47ee4c5673a68e3f42e14c35a85a1d32d385795106a1384"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2358f0fc43d8a372b4d403f0140924ba3311eaf9173d4b8f24c7da43012f1bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cd7fbf4d2e15c1ada4e960ddb20c73bdd1591a23c06dfb6d4bbb449439094e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e7a874e6732e42e81b4a00277e400ad111504f3bec2b1b85c123b5d85bec669"
    sha256 cellar: :any_skip_relocation, ventura:        "addb2658473cedaec03b5d7d59102b80db205c3e0afc367c3c3003241a4d57c9"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5302acec50b9718ada39a32d976bc563dc5c1c4e12d895d0fa5bf0fd6f5c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5018aa88e994b7112c0a552ddc19447e28d63c4f76858db78cbb0bc76fe86e9d"
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
