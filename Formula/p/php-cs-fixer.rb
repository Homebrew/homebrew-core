class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.95.28/php-cs-fixer.phar"
  sha256 "44dd8aa9b83163b4913bc39d3e26ba94221ffa03957d000e9aec252f656b0f60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8d3000b8399cc250c40417d8fa1ab490a08f655d642fbf9e53306999ad5ddbb"
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
