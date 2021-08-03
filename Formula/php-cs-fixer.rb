class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.0.1/php-cs-fixer.phar"
  sha256 "ade1ca8b7c7e8eadf1edca81c7a3ca57357472348a71d681571d658ab4b1eb00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "282b010bea18983979ab59c14c0d6d3418153e403fbfd1c94a9e7d9ac838bfbc"
  end

  uses_from_macos "php", since: :mojave

  def install
    bin.install "php-cs-fixer.phar" => "php-cs-fixer"
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
