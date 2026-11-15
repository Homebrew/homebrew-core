class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.14.0.tar.gz"
  sha256 "dc0fcae6c854fd418ebe856018a490f5a5651aeb76aa6dd1736b0158ad9788f9"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "032c7e2a9a3d3b3a1878b777089ec2458965ce2d63e926521635308770d19e6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "032c7e2a9a3d3b3a1878b777089ec2458965ce2d63e926521635308770d19e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "032c7e2a9a3d3b3a1878b777089ec2458965ce2d63e926521635308770d19e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fb4f6572ec31e385f80696db13a12c60df2d4e8c84318cbc2e4d23e502c5327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ab32af241719554bd543adab51980f6d262978c3c168c9bfbe315c96669fce24"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    ENV["GOROOT"] = formula_opt_libexec("go")

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_path_exists testpath/"osshim"
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
