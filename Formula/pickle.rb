class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar"
  sha256 "0bffcbff8368b85fcf30b098b901067c5cea2abc71c4c907c836dbb8c6f91f55"
  license "BSD-3-Clause"

  bottle :unneeded

  depends_on "php"

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match /Package name[ |]+apcu/, shell_output("pickle info apcu")
  end
end
