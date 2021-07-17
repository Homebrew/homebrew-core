class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.4/pickle.phar"
  sha256 "1ddeb6139262af3d454322f89e32802d06b2584c620c8f4cd1be64a13a46a221"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56cb810f374eeb4752ba6b25e18d14e07a44be86f3052884fcc690edd20f5a9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6929dde45a9d39e24b03d5b684ed89e5f41f396938483bc619d26b7686a23d02"
    sha256 cellar: :any_skip_relocation, catalina:      "6929dde45a9d39e24b03d5b684ed89e5f41f396938483bc619d26b7686a23d02"
    sha256 cellar: :any_skip_relocation, mojave:        "6929dde45a9d39e24b03d5b684ed89e5f41f396938483bc619d26b7686a23d02"
  end

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  pour_bottle? do
    on_macos do
      reason "The bottle needs to be installed into `#{Homebrew::DEFAULT_PREFIX}` on Intel macOS."
      satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX || Hardware::CPU.arm? }
    end
  end

  depends_on "php"

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
