class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.9.0.tar.gz"
  sha256 "c32ce1fb5a3f2c9ff046583a2109e5028823c532faadd2982836bbdd33cbd551"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f77e88c33b4a9f55f3125fa4dc72eabf4e2823b37a7a0841a66c1a7a6d58ef48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f77e88c33b4a9f55f3125fa4dc72eabf4e2823b37a7a0841a66c1a7a6d58ef48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f77e88c33b4a9f55f3125fa4dc72eabf4e2823b37a7a0841a66c1a7a6d58ef48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77e88c33b4a9f55f3125fa4dc72eabf4e2823b37a7a0841a66c1a7a6d58ef48"
    sha256 cellar: :any_skip_relocation, sonoma:         "98ee2983e3871a6c28ee28b3052772bed1ff35a2e9b19afc4a0db098c6687f73"
    sha256 cellar: :any_skip_relocation, ventura:        "98ee2983e3871a6c28ee28b3052772bed1ff35a2e9b19afc4a0db098c6687f73"
    sha256 cellar: :any_skip_relocation, monterey:       "98ee2983e3871a6c28ee28b3052772bed1ff35a2e9b19afc4a0db098c6687f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229e1440a9341fc95c5c79c6f5afe159d0075ff5225a5e987b1a8c034c42f574"
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
