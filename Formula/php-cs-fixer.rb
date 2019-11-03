class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.sensiolabs.org/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.16.0/php-cs-fixer.phar"
  version "2.16.0"
  sha256 "59a5f7fe8c6e946fdd7426c39e11d502c48549b1c79e87ddebdbf9d4c022c194"

  bottle :unneeded

  depends_on "php" if MacOS.version <= :el_capitan

  def install
    bin.install "php-cs-fixer.phar" => "php-cs-fixer"
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
