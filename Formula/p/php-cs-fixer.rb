class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.95.32/php-cs-fixer.phar"
  sha256 "5c5358423ee19cc73e436da1bf0f0171bf3ce99efd2e323fe5e312795f7763b1"
  license "MIT"
  revision 1

  bottle do
    manifest_sha256 "3ed03585487f064a34bdd0e3e1e7e4bd85125499a63e7565ea2f4a072f7bedd7"
    sha256 cellar: :any_skip_relocation, all: "71de1d5f4c37a7ccc048d754cd376d5d1b81cd4b4b1d4cf9de4d2feee45c39ae"
  end

  # TODO: switch to unversioned php
  depends_on "php@8.5"

  deny_network_access!

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{formula_opt_bin("php@8.5")}/php
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
