class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.95.22/php-cs-fixer.phar"
  sha256 "cd3babeb6080aaae47d5887eafc583b76872d6c5e97db4c3eed961698b490b84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "def6967d401cba0294a6883c3d8b69aedc6353d568f0f96c46994776b895c68b"
  end

  depends_on "php"

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
