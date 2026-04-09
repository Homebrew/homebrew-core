class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.43.0.tar.gz"
  sha256 "29744a565ff8a46d0713a077202d3b72a2b32f29ff253c98ec0aa226559fd7fd"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19786d91b956b6732c2972dfdc6916c66712c9d45cc200fc78efe834dd9763bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fdba658bbd8ae053c1d3ccb12014f9e2816fc80bf4a75b4e339b8c45be34390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7f18f44af37d37102a530e336bd8329c50af3bbb8bf1641d6f9c3626e4f384"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac59ccc32fe0f5f742afbd8e1095697c3010c6a3b7f23f58f16cd61a1b7a93c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297a131962f3518fdea0342c25236047b2d39b2af2e12d785e906bae7763c0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a388131eb6b192a0fd322459b27db4395e25e098c4dcec75756f5eaab364465f"
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
