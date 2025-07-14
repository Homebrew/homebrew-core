class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.10.1.tgz"
  sha256 "86b77b7f203ab5011a9ff1283aa817954f06c600beab5a250568033028a411fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c36272107dac7f972f3ffb669f48631209a128067578bfe4c9f095b76361c7be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36272107dac7f972f3ffb669f48631209a128067578bfe4c9f095b76361c7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c36272107dac7f972f3ffb669f48631209a128067578bfe4c9f095b76361c7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cec01ba19e8b729b2c0af161818af9c92008c0f32afc6792bb794522d032870"
    sha256 cellar: :any_skip_relocation, ventura:       "6cec01ba19e8b729b2c0af161818af9c92008c0f32afc6792bb794522d032870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9f0aa3a01845c5481fed97f706578c605fd8458f0e6a59a1e9bc8de6a7a0f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bafe03f5a60ba7e4f886fef79089fd5340e78cd00a8573960f6167979b1f2b7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = shell_output("#{bin}/firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end
