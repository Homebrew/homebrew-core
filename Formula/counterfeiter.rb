class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/v6.4.1.tar.gz"
  sha256 "bd51c80ad44881ae2008e50540fcb95a3f8e84104ee230aee86acf78c2c24bf6"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efb0f3b05250940e413d114240ec8c7ea8bd1d1437242107453004203ab10aa7"
    sha256 cellar: :any_skip_relocation, big_sur:       "1497cd531374df0a80418654e677d9c9e9bbe398739440b56059a36702357c58"
    sha256 cellar: :any_skip_relocation, catalina:      "41e2478e7d5b8b1bd4447b16c58c35b47ad6004cff416d0a229343d6bf02905f"
    sha256 cellar: :any_skip_relocation, mojave:        "042899c932431096e11d01f728c71c04055b659d7e0bd3fe9576868e7c91f329"
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
