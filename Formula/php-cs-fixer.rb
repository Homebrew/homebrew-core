class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.sensiolabs.org/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.15.0/php-cs-fixer.phar"
  version "2.15.0"
  sha256 "f398691145031290fa868c6b90aa9ff769ae910e62dbcf28222f96b967356e68"

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
