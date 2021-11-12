class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.2.0.tar.gz"
  sha256 "17b7a921ae385a91aed8d8c09485736f5a53cda2decc085a390fc7aa270fdef0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b63c46bc5ced871740bb03477cd2d32249767736e48f1bfe80c12cafccdf1ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f12d10221af1c6107fdee41954fe40f007965562dd8ddfd40d3d7e73f1d0d96"
    sha256 cellar: :any_skip_relocation, monterey:       "ed6b9d2299c63fa3f9dfc12fa87d5f2d024db88ee85e7e05784f99b3837ad6f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1f3ea6ec89b3fc7de1a058c16700bdc0503eff30213ba90e5293d5941eb25e"
    sha256 cellar: :any_skip_relocation, catalina:       "6581f609fac3c41f657f1251263a2a110a95bf499cc32642727e0fb38718f83a"
    sha256 cellar: :any_skip_relocation, mojave:         "cf7c75d380cfac624114a7291bc5b0fcd2cfa3638af23781a0fcb48f1ae605ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b0ff84f512a1f7fce1839042f72c52df4a005d1ae84226818f058cb8defc59"
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
