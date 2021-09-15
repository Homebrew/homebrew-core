class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.19.2/php-cs-fixer.phar"
  sha256 "c10c51306f21b167acab7f14576520e898c2dd150e8c8843dea13edcf8eb1665"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b49f3abfa6c10016d78c005767ce52e886ec8ad6e5794265dbc6c5869a9096b"
  end

  keg_only :versioned_formula
  uses_from_macos "php", since: :el_capitan

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
