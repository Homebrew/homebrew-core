class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "f1f925091eebd13c3aef17aa900fb2bdc9865760e25a95c32b2dc811e599bfbf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddac3c4a21b0c31f854716f365b93467f5f8d240a607eeffe3b139acb29f93c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb3d38a017cac9f7d1680ea90e2a160c0862463b12e1f89191ac43ed01b784eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a91ce1c8d8fbcb619b68d82e44626c6c0bb4eb20f8c4706a8e8ffd9f5008029"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7e388b32c9e28ec1467b6e2f8692bfc235f7b713ef609647625cae06db85986"
    sha256 cellar: :any_skip_relocation, ventura:       "7e7fb9e7e767cc73e0845bdfe42e6823fde9e3e4b66e68a26e595b286169f2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd4418c0adae01a8e31d898d6556b4b12b9b0a212df8a2221ee9e0a4a577e7b"
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
