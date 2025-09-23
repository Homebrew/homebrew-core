class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.16.0.tgz"
  sha256 "974114a692e2df4d1209983a2eeeab5a3e23ed1343b1f1211025cc500acb5e3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59b7f6297b7f32f09b047ab8dfff1352a7775f7d99d9fa4bdec6a8d15a1db96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a2d312da40afe36ca1c7bd00edb55e33b232d95280c7dc15ebe2e8579a0930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a2d312da40afe36ca1c7bd00edb55e33b232d95280c7dc15ebe2e8579a0930"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3a2d312da40afe36ca1c7bd00edb55e33b232d95280c7dc15ebe2e8579a0930"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5fd04cfe45cf461e3940bbd05b0b5ad125f14f3fe613e2b21da6b2ac18fffc"
    sha256 cellar: :any_skip_relocation, ventura:       "9e5fd04cfe45cf461e3940bbd05b0b5ad125f14f3fe613e2b21da6b2ac18fffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678f7ffa32c6a94b68ab0945db11841f2a44684fec9ea4c12f316c15beea3b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6030ea7f6869158e68ddf0bba27c228647f1b59d13835c5983180c71861e316d"
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
