class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.0/pickle.phar"
  sha256 "6eddfb9cbf4d08d0c9fffd96ddd3874a57cf0ff303c589512daafc195b8639dd"
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
