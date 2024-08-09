class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://github.com/AmrDeveloper/GQL"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.25.0.tar.gz"
  sha256 "7eb75c9bb49f8b51524155b9c5d64294ac2bcf2b00812e3c39c1dd7e45aaf96e"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    mv(bin/"gitql", bin/"gql", force: true)
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_1"]
  end
end
