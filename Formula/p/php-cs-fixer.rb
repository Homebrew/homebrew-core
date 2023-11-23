class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.39.0/php-cs-fixer.phar"
  sha256 "c23fac1632666adb2cb48d5941a2c19a05b32135b39b2f98fe05607d241cdb0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "338e4dbb71aedba72e7c40827b64ee29eee051b099cbc1e78686819f04994d8f"
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
    php_version = `php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3`.chomp
    if php_version.eql?("8.3")
      # FIXME: When php-cs-fixer will support php >= 8.3
      ENV["PHP_CS_FIXER_IGNORE_ENV"] = "1"
    end

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
