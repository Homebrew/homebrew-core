class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.3.0.tar.gz"
  sha256 "41d88f985ca145d8f3fc3a02bfd92a8fd17aa9d581623f0b5d4b022ca88f2712"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb42ea25305a98a90c0640c9e1b27b38629778b5bdc2343d7947ccdc06d1963"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb42ea25305a98a90c0640c9e1b27b38629778b5bdc2343d7947ccdc06d1963"
    sha256 cellar: :any_skip_relocation, monterey:       "ba47b9fc0c0a5de5e109a8c7f5ab5cea74dfe233e892f2d3e585bfad49293d11"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba47b9fc0c0a5de5e109a8c7f5ab5cea74dfe233e892f2d3e585bfad49293d11"
    sha256 cellar: :any_skip_relocation, catalina:       "ba47b9fc0c0a5de5e109a8c7f5ab5cea74dfe233e892f2d3e585bfad49293d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f509d2d0ae3ae0d472c6b61d5d0ea74fb4be545c2c84251bb0fae054a3ff280"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gofumpt --version")

    (testpath/"test.go").write <<~EOS
      package foo

      func foo() {
        println("bar")

      }
    EOS

    (testpath/"expected.go").write <<~EOS
      package foo

      func foo() {
      	println("bar")
      }
    EOS

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
