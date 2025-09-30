class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.17.0.tgz"
  sha256 "4e178ab205a278331c3e564deaad4e09518f4487d98f7ecba0a88c08198c6d3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4848c3f81656d93e36ebeec8a7f90eb36b732e7da93db08b58b097678f5284f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4848c3f81656d93e36ebeec8a7f90eb36b732e7da93db08b58b097678f5284f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4848c3f81656d93e36ebeec8a7f90eb36b732e7da93db08b58b097678f5284f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e05e7b301c363f227b9d4fc390becbbbdb3679ed1a7f26f1f304d93c7937afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ada7d6a7ce4b3d0017bdb505d10e17d53eaa8884801441cff4788b83f8f973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627672fd056e86124b6614aba6b0343cd1a1ff06aad46d272708a7c0490a5c4a"
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
