class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.19.0/php-cs-fixer.phar"
  sha256 "dcaf7556479a1cfc7ece11a203c4247d61fabe86e509b0e29539111f6b82018c"
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
