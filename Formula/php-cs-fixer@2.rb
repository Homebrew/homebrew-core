class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.19.1/php-cs-fixer.phar"
  sha256 "5a7328acec7a62a7c61dd5da066267381ff42afcffd19b2543d50b06ab297a2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f80ed35e0644fa2eafc81ab81b4320187f3257c0819fd43e70e6f7cc2003b3d"
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
