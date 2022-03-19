class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "a03c3f1428bbb29cd0a050bb4732c94000b7edd769f6863b5447d2c07bd06695"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8274c5472932a77b2bf25446d6fc241a8d36a261b82485ce1c54cbfaa9f3ba6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8274c5472932a77b2bf25446d6fc241a8d36a261b82485ce1c54cbfaa9f3ba6c"
    sha256 cellar: :any_skip_relocation, monterey:       "8687db988cf81f6c41f2fec5fc8f4af591de95ee7b77e1f9b61c799e35003d56"
    sha256 cellar: :any_skip_relocation, big_sur:        "8687db988cf81f6c41f2fec5fc8f4af591de95ee7b77e1f9b61c799e35003d56"
    sha256 cellar: :any_skip_relocation, catalina:       "8687db988cf81f6c41f2fec5fc8f4af591de95ee7b77e1f9b61c799e35003d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d90be70b43fca50f6d8c75fcba1d7418b3fb888c4af51934b6d0a5279af461"
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
