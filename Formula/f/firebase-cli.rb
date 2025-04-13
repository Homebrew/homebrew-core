class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.1.0.tgz"
  sha256 "000b797e70aef9f76740b87033548e89124fab11acbeb17e64be1a30006225b8"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "177c0170854300c8fb3a0cd5973da40cbdf0bfccf016a30777d25699be40799f"
    sha256                               arm64_sonoma:  "765452975c224c7989de95cfac93821ee59d70de8eac9c964b6374f881cbb9af"
    sha256                               arm64_ventura: "16e5f25bb7358eee185d5609055192616d6455467647d007dc31f70791e5aa7d"
    sha256                               sonoma:        "abd9b25e47abfdf94ae8d9092432681cf6d9d37ef7dc4def4ccb0c8bbac2bf84"
    sha256                               ventura:       "88ead664bf7c04c6eeda7251dda33f82036e4ac6e45a474868db5f0245af0d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3cac81e44b3c6aeacfbf8acb57911c5138c1a03f402b36c1ae7633ec6be2b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "965a393c8f19f42fae9dee9b38776cdf6fab1860367f9d9408a445536e0356fc"
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
