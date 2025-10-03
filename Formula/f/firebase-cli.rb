class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.18.0.tgz"
  sha256 "2e556583f2d8c898d8c6f076f35d3b6ae7101b53658df211a9d08ef0b46d6128"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db9d8e740bd078d3af3f7d4e23dd6e3b1d3bf0a5107c3452a75e1ded067b091e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9d8e740bd078d3af3f7d4e23dd6e3b1d3bf0a5107c3452a75e1ded067b091e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9d8e740bd078d3af3f7d4e23dd6e3b1d3bf0a5107c3452a75e1ded067b091e"
    sha256 cellar: :any_skip_relocation, sonoma:        "957c3d5e91f176487693f3a05c2b3ff8a40ca5f7d2e1dfea6d9a14cd7ac9268a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc664ab9696ea16416fdeba7bb92db386910fb0b77a266212ddc3f951a42db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777a102886cbcc9cc3cbbb81d185dec3c96b09d0ee9772a885f27d37323327d5"
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
