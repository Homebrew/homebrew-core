class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://github.com/AmrDeveloper/GQL"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.35.0.tar.gz"
  sha256 "a44d97f1932f63212070908f7938823f0dca7e04d69cc61ad421d56d47be9d91"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579ed70798f8b626af0cb58eab0626bd20057802d18c7b37eec4dcaa3e021913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08add3569d9dd0d1d0bc79885446b62dc812ce09e248a3d941c82741174605cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0d843063460ad33ddd78bf15a57e963c1c289d6bec2b68760b98d42b5a77ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f06ad42e239a5f899dde72bf4c1c50bb18ee589b2292778e0a9afe4daa1403"
    sha256 cellar: :any_skip_relocation, ventura:       "73638f1e7bbeff5985f81f928b11af8546f853ee4e50e1fb65b9d054691ee66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c81bee069eca045217c0632bc9d07ab63e7f78ef36f1ace877bff64d8cf3f20"
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
