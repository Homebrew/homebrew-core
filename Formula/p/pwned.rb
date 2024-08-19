class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-12.1.1.tgz"
  sha256 "9891674b8c269b5be7af510bbbe46c5edd04f803053719625797b38eef840863"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af219c3bc8235292cadb96f309d58d2e16f9f26951d4542df3ee95b3067f3089"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af219c3bc8235292cadb96f309d58d2e16f9f26951d4542df3ee95b3067f3089"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af219c3bc8235292cadb96f309d58d2e16f9f26951d4542df3ee95b3067f3089"
    sha256 cellar: :any_skip_relocation, sonoma:         "af219c3bc8235292cadb96f309d58d2e16f9f26951d4542df3ee95b3067f3089"
    sha256 cellar: :any_skip_relocation, ventura:        "af219c3bc8235292cadb96f309d58d2e16f9f26951d4542df3ee95b3067f3089"
    sha256 cellar: :any_skip_relocation, monterey:       "af219c3bc8235292cadb96f309d58d2e16f9f26951d4542df3ee95b3067f3089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6362e175b7c449811805cca017043eb75b2b82f8fd7b4e2550559398619714"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
