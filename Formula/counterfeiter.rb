class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "a03c3f1428bbb29cd0a050bb4732c94000b7edd769f6863b5447d2c07bd06695"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c17fd8e1e8fd737221d0b63871065b6dedb5945443338df5b1f919fe6754bff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cdad6769afe63f7dfdaaac7758e0bf6cc5d8265a4ab274d2f008b36ee201eb0"
    sha256 cellar: :any_skip_relocation, monterey:       "f953e0315346492e1ea30d22159fbc8ebbe1cb24979855a361faba7ceaf33c30"
    sha256 cellar: :any_skip_relocation, big_sur:        "400bb2b8fded512c283254548bea1e294b61649ec8a84218966e8a710117ecba"
    sha256 cellar: :any_skip_relocation, catalina:       "400bb2b8fded512c283254548bea1e294b61649ec8a84218966e8a710117ecba"
    sha256 cellar: :any_skip_relocation, mojave:         "400bb2b8fded512c283254548bea1e294b61649ec8a84218966e8a710117ecba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e46a570a5d8914659a1184f373db09e096c9f3e4954daaff5bcb1328286266"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
