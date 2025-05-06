class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.2.2.tgz"
  sha256 "3493b9d12c491d06cf9fb32009edf40d376dccc3d34158dc52af15bb5db5017b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "2a3f2219175bc0e40c3367892ee6689baa50a83037fdf0c9e99d6665610442b6"
    sha256                               arm64_sonoma:  "bf203d3ea282162ba10533e05554334a5bf13f93a8f0e58902f62c45555d4d23"
    sha256                               arm64_ventura: "bdf15eb630c5de33ec975eeb9964bf7c8d7c5562916c8bcf452de30d291d69ba"
    sha256                               sonoma:        "6edf9ff456ff4e4d63ccadd25843672027dc1ef5dfaab04a5620a0c362944993"
    sha256                               ventura:       "ee34b5a915c5da280365e7a7f362978c9f2dcf79f2f86af17cfd82d77c467c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edfd1abb96c1cb8975a1600cc6fbb1df34f090f9a0b42d3071ff6197f99fd00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b3ebf7d3c0623c6a48acd17a5ed4516dfcdd2c3feb836f5a5011205355dd542"
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
