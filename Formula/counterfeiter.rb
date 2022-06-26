class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "a03c3f1428bbb29cd0a050bb4732c94000b7edd769f6863b5447d2c07bd06695"
  license "MIT"
  revision 1
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e43cf62248f6e7ff02b67cfffa38f5f1ae81b3f79d6e289bebc16a814238ad2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e43cf62248f6e7ff02b67cfffa38f5f1ae81b3f79d6e289bebc16a814238ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "d77a7211900355c0e440921a8b06fb8e1d91a650d98d1eea280bded849dc2739"
    sha256 cellar: :any_skip_relocation, big_sur:        "d77a7211900355c0e440921a8b06fb8e1d91a650d98d1eea280bded849dc2739"
    sha256 cellar: :any_skip_relocation, catalina:       "d77a7211900355c0e440921a8b06fb8e1d91a650d98d1eea280bded849dc2739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ae35345e995a8d7ab54d0c08d10dbfefb2fc28b47da0e93b6bf16c1f6f45955"
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
