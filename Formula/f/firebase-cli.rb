class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.29.1.tgz"
  sha256 "45bb8c24636d88570186661437dc46e2aa35a8d12455781ada42b157d82eb330"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "9ec6b54f430120deb4b755adde5d9d29dc2f47ab37846d0576c0be96a8dfa777"
    sha256                               arm64_sonoma:  "5f7f27fcc97d43d6776a3c0d89c7123aa00d7055420ff333627e0ae2db130890"
    sha256                               arm64_ventura: "1378070e9eab70aca50edf5d25d196b2b1ec690664ffaf346a09b5901525a179"
    sha256                               sonoma:        "21223d7421e6df0f02c79d72e3ee806ed46cae1a6747b6767617a9faadc3bb93"
    sha256                               ventura:       "c7bee521eea8f791a65460fff84b7655826c73de09432fbd1f05d57dbbf7a2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5795f9ad614bb6c85bba68cf8c21905b0266b61a0b02bf81f0ca1bcc26c136a7"
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

    output = pipe_output("#{bin}/firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end
