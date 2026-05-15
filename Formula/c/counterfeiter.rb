class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.12.2.tar.gz"
  sha256 "094811ab5e8f9e64aa7f7cdf832b3a7c9042ada2f60ba79d7d3cadff6e65565d"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9403500145d299f72c01219bc34bea7b3b3b55259a49153e7506a1df2e9c05a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9403500145d299f72c01219bc34bea7b3b3b55259a49153e7506a1df2e9c05a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9403500145d299f72c01219bc34bea7b3b3b55259a49153e7506a1df2e9c05a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0589dfe76ddd6beaf641ab65abe6fcacfaf42b99b2fa862d759def2f4a9db824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b903e92025b76299f7329c2a98945c948a4826b61d39ffed3f9ce4b469abd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6814f0d168f88f12cb5e32189d934edc74effde1ec29f9ae580f97004201c34"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_path_exists testpath/"osshim"
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
