class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "acff9518cf4ad3550ca910b9254fc8a706494d6a105fe2e92948fedc52a42a5b"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84fb5a69b75c1406537fbeb7214db70e9ba98557e4efdad696b93a9c9f2ba1da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84fb5a69b75c1406537fbeb7214db70e9ba98557e4efdad696b93a9c9f2ba1da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84fb5a69b75c1406537fbeb7214db70e9ba98557e4efdad696b93a9c9f2ba1da"
    sha256 cellar: :any_skip_relocation, sonoma:        "04bf77a6f316b04142eb28a24ecf20c79551fa06aad5c4a89f09c34104ff098c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be16c656035b58ddada2575c81700b4f13280afd3ad472dae07308d06b449e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75aa7b38f10358e98e5a112f1d49a5cf65a60ff85d1da0aa0fea96789c2bcb01"
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
