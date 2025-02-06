class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://github.com/AmrDeveloper/GQL"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.36.0.tar.gz"
  sha256 "741a5160e4f60f4b19fa55a0ad265207393d8799576075cd2cf6b2494fa182f2"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1cfcf9e9c70b4883b51f7eccbfa50fa101af57f8ed6ee766bb15f6a8c802621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef15ac7fa7faeea0d975f273e759343521d8acb6cecbf0bf71e8a95b9237a178"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d728dac46e7bf5d696694bb8c451e3a4e5cc64643ff150aefea0d52127708c96"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea102723a836bd4df36467debf17f8c281399c16dd8356a2c1e8cfedbb57bbc"
    sha256 cellar: :any_skip_relocation, ventura:       "916f098fd3282615228fa26babe703a7d2ab7e6dcd1fc6f5801e802f365637d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f4615e5a45b78aa3e6ab6849cdbb352d6f297e5756b31f4c239b093af398b04"
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
