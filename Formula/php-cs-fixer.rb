class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://wp-cli.org/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.11.1/php-cs-fixer.phar"
  version "2.11.1"
  sha256 "cb1092637760c7283f63af3ef74ae835a861b123f8592a0aa195bd757cd1e088"

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
