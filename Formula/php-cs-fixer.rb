class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.2.0/php-cs-fixer.phar"
  sha256 "4ac7814b2ce59373aa610d7682a6dfacf66f9d59e90fb4f1290b59943c141797"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e78739464adae18998a254ca4d1c4c5242126ce0d71d55ce9cad96a49d315eab"
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
