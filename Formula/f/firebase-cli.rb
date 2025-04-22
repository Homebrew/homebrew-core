class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.2.0.tgz"
  sha256 "25b5d162f8e50f9604ab918ebe58b39d33df89c871420ef8cfa02c81f395962b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "29f604d622b23a9945b5a92ab8d42c9ea221719a139111f60f5a9497b9bd4793"
    sha256                               arm64_sonoma:  "78f85b4ca5f64625cceef6d586134ae5968c71b6c3c52fcefd2c101ad65e0a13"
    sha256                               arm64_ventura: "35aeb3f75dcf6327878b2d1a217486716320f2b46baccd141a17fbaeff83f19c"
    sha256                               sonoma:        "0abfd997feb4ee8ccbd2229c3342363c88820b57c0a5adc98c64edea06558f6c"
    sha256                               ventura:       "e2aec48632ed5bdaa6737634672a25a5dbae593c769b7e5374a6f16f464824dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c887c2da2f766e3b713314b17c74d05681466ca070b4819d129d80e09a697ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b4f53d2d74e4e3fa24a8127bb10fbfe09d1a9fdc4aee8e4a84ad1b0b736b7b"
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
