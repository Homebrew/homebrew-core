class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "5f3158f665d1d49a19f3ed48981366c892b68904b2b34cb893c6fe3ff8346929"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a2552723980c41aaf04ea730a7f1a5f013e85d712f21df89b6b8bed8359f7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8a2552723980c41aaf04ea730a7f1a5f013e85d712f21df89b6b8bed8359f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a2552723980c41aaf04ea730a7f1a5f013e85d712f21df89b6b8bed8359f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a83edb0b9fa74e41b360584a285c3adfbf88310acba657950bc2f6acccaaad64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f8a221bb7d92848ff2193fa7533528ea97464d784c874766f767053a9fb6dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3461fcf9a79bca4da5728705c5bed42370d01e08364c106109e86df515c4a3c7"
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
