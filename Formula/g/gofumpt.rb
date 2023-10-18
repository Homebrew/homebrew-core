class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.5.0.tar.gz"
  sha256 "e27f04b8b5619747ebfb955699d6895c1e4c7c5e4478507ca4e2d8b658b8b51c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "677ef719a80c09ab4abc7bbd5bfebbcdbb862b6d0b9cce4f1247ba0ead56bc52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "241c7a1670da1fd7fd0220237c541fd5e3fcf45d750084a9b9ad354b01929a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241c7a1670da1fd7fd0220237c541fd5e3fcf45d750084a9b9ad354b01929a01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "241c7a1670da1fd7fd0220237c541fd5e3fcf45d750084a9b9ad354b01929a01"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7b47a8c7ed5c2bd1bba28da59a37e24fcf0eaba6155fffc26dd0f7d2001fe76"
    sha256 cellar: :any_skip_relocation, ventura:        "898b89543bde7a2d79d2f298960115cafa3a8f566f18f97ccce67d7715518a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "898b89543bde7a2d79d2f298960115cafa3a8f566f18f97ccce67d7715518a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "898b89543bde7a2d79d2f298960115cafa3a8f566f18f97ccce67d7715518a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c200163cfb0748b11aecc5bce47c8a4071541541a0a01247a816a2c948a6105"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
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
