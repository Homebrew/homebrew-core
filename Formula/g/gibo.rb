class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.20.tar.gz"
  sha256 "29ec9443a83256c8c78ff42724c1e35cc3cbcf4cb91a4823383125c75e1e89c2"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efd799aee3f1f9db69f25f8dfc389e40bcf2985705593d31593b576e49be93f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efd799aee3f1f9db69f25f8dfc389e40bcf2985705593d31593b576e49be93f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd799aee3f1f9db69f25f8dfc389e40bcf2985705593d31593b576e49be93f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "25db33f4f269291e3d440bfc699ff0c02f45d808252e5ed6ed11870bfe14c76f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a953a02849c4b714e7be8ac456d889ed52037e0669dc0ae2c15da1894d8350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317bbb6430fc5a7653b29b91f9ca7d213bac5c59e46dfb296f41d89c53f896b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
