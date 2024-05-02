require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.3.0.tgz"
  sha256 "a2cb9218f086e8877691e7b7002b2f20cde823cb27a87c0255fdcbf74dde5e46"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15b7edcb85f4caf7a8e444dfd891017ac20e2f94189f593e9fb6403a08eb9860"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15b7edcb85f4caf7a8e444dfd891017ac20e2f94189f593e9fb6403a08eb9860"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15b7edcb85f4caf7a8e444dfd891017ac20e2f94189f593e9fb6403a08eb9860"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c53449fe9728ea230148d33d5438b48c7c3054f6576aa0f14f0e2f617a41741"
    sha256 cellar: :any_skip_relocation, ventura:        "6c53449fe9728ea230148d33d5438b48c7c3054f6576aa0f14f0e2f617a41741"
    sha256 cellar: :any_skip_relocation, monterey:       "6c53449fe9728ea230148d33d5438b48c7c3054f6576aa0f14f0e2f617a41741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b7edcb85f4caf7a8e444dfd891017ac20e2f94189f593e9fb6403a08eb9860"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end
