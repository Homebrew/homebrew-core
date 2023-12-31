class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.30.4.tar.gz"
  sha256 "865479367dca7623cc20f2c9b2ab62c14ac4c43c692412e34d64bf8bd07cde2f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8c4f957d5a7affb5f5d479a511dbec8bdd3a635665956e754ee91f36e1f8f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c18d8ff94e721dc4d049a0fdfdf6d6ae080993c345b17ecc69c71e7b46a0d60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "044d477c1ea4a93f42c775a5021b67da2ba4963c4db6f680eece012dd3dc2f64"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1cf8e22e5f0226f7832c77e116283578feceed7b08ebafd25f92b97045b33ca"
    sha256 cellar: :any_skip_relocation, ventura:        "eeb39a20c50cc83764d7b0ae6e49755d48b34e5be667a0e1a1a44edd276fb4ab"
    sha256 cellar: :any_skip_relocation, monterey:       "49d68102dde6c41938b85b5369dd948d0f701c6f89af6c73d28095dc67fd4e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63998c74398474ae6c314bae832707836dc98d174599d6f2e70c385e18f50c59"
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
