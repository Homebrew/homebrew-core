class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.95.31/php-cs-fixer.phar"
  sha256 "4c4fb157a6adf633ef130abda3bf208c81918af941404bc169d16081fdfaea8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2870cc2c93e5a3cdd1359e6349ac7ed4bda1d08c78b97edb85acf385ca50a7cd"
  end

  depends_on "php"

  deny_network_access!

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{formula_opt_bin("php")}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "require": {
          "php": ">=8.0"
        }
      }
    JSON
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    (testpath/".php-cs-fixer.dist.php").write <<~PHP
      <?php

      $finder = PhpCsFixer\\Finder::create()
          ->in(__DIR__);

      return (new PhpCsFixer\\Config())
          ->setRiskyAllowed(false)
          ->setRules([
              '@PSR12' => true,
          ])
          ->setFinder($finder);
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
