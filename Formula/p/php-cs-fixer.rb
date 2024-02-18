class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.49.0/php-cs-fixer.phar"
  sha256 "7271fa48411a121ed7f739478070fc78ea5a4940e7aa12f648c9cd1928f59c94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63f848e317478a8b9f7998a40af84ddef932f3fb90d2d395d061bad4dd25e4ab"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
