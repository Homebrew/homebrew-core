class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.2/pickle.phar"
  sha256 "4fee7dbfe44c93c939fbc7d4b1929a3255e2d042b0e46685dac80a5e181c102e"
  license "BSD-3-Clause"

  bottle :unneeded

  depends_on "php"

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
