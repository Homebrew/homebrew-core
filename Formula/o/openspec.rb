class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-2.1.1.tgz"
  sha256 "89f20d311c96408aff8d0abd880a063df153f7ec3a7a8abf418d27afa298440c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bea148cddc1605831e4035be77258c32faa6149382a837a2b2639523accd08f"
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
