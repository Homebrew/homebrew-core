class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.29.2.tgz"
  sha256 "9b7746c0cafbd39dd0636864d7de25ba84630f8c1317ce1dabcc0abe72e92722"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "030d9a7b9a537619f31affc3de5b7878e2bc487f35af7db20e090dd708ad8fb1"
    sha256                               arm64_sonoma:  "c0c59bdcfade6abc634b8ab1a66b2272d2997436d7895c47cb01dfdb1be9e580"
    sha256                               arm64_ventura: "46ff587458fad612641e41fe53fd376012a55a11cda1dcf51134ca04ddfa1362"
    sha256                               sonoma:        "a9421832223fe28c6ad0af3208cdd31bcb191d69f98e12745c536c0bac6c9f80"
    sha256                               ventura:       "2cb2bc60038befa27328b25e0b07f8c3f716cf131e490125d39f9ed225250942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c858f53cb77600a4367a1857f1a528b6309eaad1313da509a0e7349cb26dd0"
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
