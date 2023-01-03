class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.2 on the next release, if possible.
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.13.2/php-cs-fixer.phar"
  sha256 "5cbd6179122f4bcdcc988209aa19019ecb300890589ed8b26fa452efd63046bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "104989a41dede365583c39bc41ad97b34cba666dcf48e68647880b0a1d8660d4"
  end

  depends_on "php@8.1"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.1"].opt_bin}/php
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

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
