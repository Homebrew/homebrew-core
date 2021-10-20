class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.2.1/php-cs-fixer.phar"
  sha256 "5d77329b72ae79322fd24e1737f1606e50f77cd42140661e5d8ed6917ddc4617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdccc22b31bde4d2c8e83b203c7799393f2c5c689d2b7482898b16da07ba07e6"
  end

  uses_from_macos "php", since: :catalina

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
