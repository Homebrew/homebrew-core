class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.5.1.tgz"
  sha256 "c324d80f51c1fd578acaba876889afb8c238bdd79eed82ca32a361a77b37243d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9ff707db6403c00c178299d4ccf7c53327d4a78a3abe7c0b6afc05aec58246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9ff707db6403c00c178299d4ccf7c53327d4a78a3abe7c0b6afc05aec58246"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c9ff707db6403c00c178299d4ccf7c53327d4a78a3abe7c0b6afc05aec58246"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8203c07a10d4822cb542ab11eaef642a0f61ce1caa9bd4beca8adfc6400e36d"
    sha256 cellar: :any_skip_relocation, ventura:       "f8203c07a10d4822cb542ab11eaef642a0f61ce1caa9bd4beca8adfc6400e36d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0280d04fddfb882e78e354f137efcb8202fe1bd99028f6509a73a47bcef31b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ac902e13ab13fa58dd5115967583499fbdae0aa1404c7b7d581ca25e29fc2c"
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
