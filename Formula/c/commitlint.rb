class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-21.2.3.tgz"
  sha256 "4eec37fb1f5b6cbac943c03ab4c2ef622326adbe521edff71dfeb32246d1539b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "957e4a1664832b28a41e3c0fbc387a54f3b3b059ecb3e10e5cda57a5212f711e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "957e4a1664832b28a41e3c0fbc387a54f3b3b059ecb3e10e5cda57a5212f711e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "957e4a1664832b28a41e3c0fbc387a54f3b3b059ecb3e10e5cda57a5212f711e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "087bb8d14d9854e5b5aecee52ac99457058a66477833e64a6061f5a8c6602e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a1a9f3f6e6de6df570fa0501765d066433be7906743ca997509c01493fcce00b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove comment to build :all bottle
    node_modules = libexec/"lib/node_modules/commitlint/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", "HOMEBREW_PREFIX"
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end
