class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.9.tar.gz"
  sha256 "f044d1202b232dc3e482bf9f46166e2af3e4d0aea4bc749bd106766e9b76b78b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee3ea741e16af05656520a6170446b3db3a4a85cecd1c86f7be33f2bac5e678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e99737a06a7beb5a3457c8bd48da11441e81811fe8177677eb83acca1b719c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "36bd47c952b2de98048df5ddfaac51deeb4d0e6602d622a3b20f8ce2f7373bda"
    sha256 cellar: :any_skip_relocation, big_sur:        "b947ddd7ee3fe391cdc9a5db398d1f3935dc4198293990bc63ba784ce1cbc84e"
    sha256 cellar: :any_skip_relocation, catalina:       "0206a6b66a7c688658afda9171e42abd222a71e54045868a8ca3078cb83eae89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0bd4ceca9599b524843803fa063b0756a4b99f2b84b0a7cfa0e5dbe6a10125a"
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
