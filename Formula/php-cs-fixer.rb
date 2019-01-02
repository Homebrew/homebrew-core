class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.sensiolabs.org/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.13.2/php-cs-fixer.phar"
  version "2.13.2"
  sha256 "83dd2ba85c329b7c5f09ba45e839959f1e99126b4a65169fd5b620d1b3903670"

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
