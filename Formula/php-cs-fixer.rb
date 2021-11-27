class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.3.2/php-cs-fixer.phar"
  sha256 "8a7cb6fcbf916f01d4b423b7850b4401bc687275011b6f437322679a4fc4613f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9979da8cbb781fd78fd4a79d36a4be3fd0b8e2bbdff1e89b66e930a0452f0eb"
  end

  depends_on "php"

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

    ENV["PHP_CS_FIXER_IGNORE_ENV"] = "1"
    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
