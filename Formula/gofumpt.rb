class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.3.1.tar.gz"
  sha256 "514faa1401511c5634eb906ebaa12c26dd1f7227f80b835c9b21af15bbd0ec3a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "474830bed41943d0f1d5ec322fb2bbd2884e8361bf4ce3b875b89220b55118e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "474830bed41943d0f1d5ec322fb2bbd2884e8361bf4ce3b875b89220b55118e4"
    sha256 cellar: :any_skip_relocation, monterey:       "a0cf68ce6b440d73d0cda78a1bc0736e2f4cdc95d3b9a6508895b495dae2110d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0cf68ce6b440d73d0cda78a1bc0736e2f4cdc95d3b9a6508895b495dae2110d"
    sha256 cellar: :any_skip_relocation, catalina:       "a0cf68ce6b440d73d0cda78a1bc0736e2f4cdc95d3b9a6508895b495dae2110d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c95870742191146c3c4eca0bba4e7dc904711145d4eab50c3976920fdf1b1cc"
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
