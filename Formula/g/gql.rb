class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.39.0.tar.gz"
  sha256 "f18dcb9bb6f574dfeb6d352bcfb4695903a3d6676633e84365b0f3d96bc295d9"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a70e0dae86235b6454ea5fad8cb064e20b5b3a6dfe3026fb68a8023b6c10519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec2f8476cf1848dc6409f68759e733e6be5bdb3ce434b8aa036ba75255958320"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1b97a800e5e9115952124e9be43d4c81a8739c32958c949ff5fa3c4a57dbe42"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1112423136518b23c5e9576178958280c9aeecd74067cc6a7a99fcd38331672"
    sha256 cellar: :any_skip_relocation, ventura:       "bc2529339d7238a478e596b06b15fce15a03d970287cc50e9f48677b0260d922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6066a107532dbbb0c8b616d0fd20eb8319d0aa5184ba5a2486397d03b062bbad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b7ec2d096f0a7954131a023b0968a43402ac55df0b774d2bd4e10236aa682df"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_0"]
  end
end
