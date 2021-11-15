class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.7/pickle.phar"
  sha256 "a1c02bee3a364f1f9bf53a41cb355e450b3df0c89de0e75a20a89e9d7ac7069b"
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
