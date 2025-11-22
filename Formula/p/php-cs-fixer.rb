class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to PHP 8.5 on the next release, if possible.
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.90.0/php-cs-fixer.phar"
  sha256 "43fd63116dd8937ac609bc13cf008c6bb9f174619e3452c25e364ce1255cbae9"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d5dc14814e7a17201cc776722e8d2e89d7b20f489fa4741883e6e4b0c419a90"
  end

  depends_on "php@8.4"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php@8.4"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
