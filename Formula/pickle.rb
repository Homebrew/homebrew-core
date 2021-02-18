class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.1/pickle.phar"
  sha256 "69bd6db9d9a2b795f1bf68dcba66e35be1b2dc82848c1a1a6ed9f9a1ef429dbe"
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
