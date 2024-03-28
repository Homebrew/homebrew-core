class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.5.tar.gz"
  sha256 "87b0066fa09f752f014da49cf785321b8dcdf10548c1aa29bc92064d163afd70"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4049cf68ce0085e21bc2b4f9c4ca065768356fd730f04fc5039de2ee6cce0d3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dce582f5eae15b2e3d0451c1af0e9be40e244c722b1bf26473371a1e1bf4ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d3eddded2df185d7a09e639b989f820249298192a74e3114c4f60213403ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "35d18d29b241d5d86e0f26bfd393e73f1ccee6815ccf9c97b210e1708c9b6f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "39c0259712c2a55fae92ffaa5b6f00c615d39d5caa003e9c4df79c7f0f2ce6a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d9030d6345e8d6d7687b98bc91f8e4c9af17da363d1101bb90a8f3443e1d4bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e29ac06480dd4c1ef864146e78c6d640b04e215275fb6d5f40b80e896affbfc"
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
