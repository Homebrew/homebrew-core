class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4e0e23832e74779ca0fa6af8ca7c15dbf20599dec34c8c96607b9b2e59157cb7"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "488018b3c1f2b6a38a36fed5953b00821d7aa574f86fd7dfafc1335ef4178720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488018b3c1f2b6a38a36fed5953b00821d7aa574f86fd7dfafc1335ef4178720"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "488018b3c1f2b6a38a36fed5953b00821d7aa574f86fd7dfafc1335ef4178720"
    sha256 cellar: :any_skip_relocation, sonoma:        "5298ec4d0ea2adff2d853248962af203af36e872842c5426131ace834f37867a"
    sha256 cellar: :any_skip_relocation, ventura:       "5298ec4d0ea2adff2d853248962af203af36e872842c5426131ace834f37867a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb5b934412a0cdc5d4a11bd943ae8a37e44d737e48579287792bbeb30c2b1ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de1792a6b9f36ff6a75d4bfe715b76a622728bc3441c2d23f39d01e564d7543"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.go").write <<~GO
      package foo

      func foo() {
        println("bar")

      }
    GO

    (testpath/"expected.go").write <<~GO
      package foo

      func foo() {
      	println("bar")
      }
    GO

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
