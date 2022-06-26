class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.3.1.tar.gz"
  sha256 "514faa1401511c5634eb906ebaa12c26dd1f7227f80b835c9b21af15bbd0ec3a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a788943e18f8941a6dee5c0f60b36f9e8cd360ff5b50b3e930acfd433b8de30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a788943e18f8941a6dee5c0f60b36f9e8cd360ff5b50b3e930acfd433b8de30"
    sha256 cellar: :any_skip_relocation, monterey:       "2785ea620e532aba380160adfece8e20c9d09dcd7df2a630e4d2625124675cf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2785ea620e532aba380160adfece8e20c9d09dcd7df2a630e4d2625124675cf2"
    sha256 cellar: :any_skip_relocation, catalina:       "2785ea620e532aba380160adfece8e20c9d09dcd7df2a630e4d2625124675cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f42aa1fb0d0af2d0a050b9f37e9648030663946015e64411eaa8823369fb35"
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
