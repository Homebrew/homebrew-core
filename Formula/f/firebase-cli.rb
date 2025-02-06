class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.30.0.tgz"
  sha256 "ec9e1a64e7334c6bf55a8708d9ec990bd423baefa3bfe3cca8f00e5a7e2ea1d4"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "21bfa5feafd6ac52b4999af5ccc4bf16fbbf32f23d7d1722ef10411e936155db"
    sha256                               arm64_sonoma:  "f35fd47c60c9c63dfeeb96f434f1895c4eebfd86c17b1a31667e1df1a5734ef4"
    sha256                               arm64_ventura: "1f69f57dad4ab37acd7bfa4942ad9684593ea7c0707989f75d650fa894114d32"
    sha256                               sonoma:        "ef007551b8f055ecce17f304172b7b170486d4e22ca2a9aefa2c0496c429daab"
    sha256                               ventura:       "01719bbf78af8bd79554477a0e3a0211e0d82e05268f131aa295077101bd8ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b801cd302c53931918f45a230a25536c2786c16d52df2d74fc62ac5f58021934"
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
