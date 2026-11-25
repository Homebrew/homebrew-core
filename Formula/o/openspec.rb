class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-2.2.0.tgz"
  sha256 "581d78a058c9e0d11e40b0f7a1ffb36282e54394f22ac02a8d04f3b1bb408cde"
  license "MIT"

  bottle do
    manifest_sha256 "f9def3091fc69795678bc26e83c21dc017cca8e3a46cdb14cbae3ae7d909d86a"
    sha256 cellar: :any_skip_relocation, all: "d4ee6a7a6b15347a658032cecb12d94a948d651cd1fbf0c5f6faba87cde83972"
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
