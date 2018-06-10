class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.sensiolabs.org/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.12.1/php-cs-fixer.phar"
  version "2.12.1"
  sha256 "a2adb81f74fc583700295b7c22fbb267b6103a70b5cd6c315de5b6c6c158dcc5"

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
