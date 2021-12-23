class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.9/pickle.phar"
  sha256 "e3f787deb31862cdf3b301a08a1a3c46e311c8e1cab7a177b70983de87d2d2e9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cb6da56e1d2006229fe4faaedfa70c0e3cd6a0ed54d87a3965175a8831a599d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cb6da56e1d2006229fe4faaedfa70c0e3cd6a0ed54d87a3965175a8831a599d"
    sha256 cellar: :any_skip_relocation, monterey:       "d32f594be0e7dcbc0d24826ae517081f38fe267f96f7bc2f4e40cb59902ccc05"
    sha256 cellar: :any_skip_relocation, big_sur:        "d32f594be0e7dcbc0d24826ae517081f38fe267f96f7bc2f4e40cb59902ccc05"
    sha256 cellar: :any_skip_relocation, catalina:       "d32f594be0e7dcbc0d24826ae517081f38fe267f96f7bc2f4e40cb59902ccc05"
    sha256 cellar: :any_skip_relocation, mojave:         "d32f594be0e7dcbc0d24826ae517081f38fe267f96f7bc2f4e40cb59902ccc05"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
