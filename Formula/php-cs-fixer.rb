class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.3.2/php-cs-fixer.phar"
  sha256 "8a7cb6fcbf916f01d4b423b7850b4401bc687275011b6f437322679a4fc4613f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "964e27354e1f618827381479ddebae75cc20b5ab3349f9a636c39eab9e7a3b4b"
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
