class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-2.1.0.tgz"
  sha256 "eccc398bb23fd60085e267a2d2ad78f062b885dc627ba01aa7a8f202163255db"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "16f72f20bac22d0c2e116e0289577d7838a9059ca2ec5b6f3beb65ab44b67000"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Build an `:all` bottle
    inreplace libexec/"lib/node_modules/@fission-ai/openspec/dist/core/completions/installers/bash-installer.js",
              "/opt/homebrew", HOMEBREW_PREFIX

    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
