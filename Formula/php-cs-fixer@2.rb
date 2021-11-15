class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.19.2/php-cs-fixer.phar"
  sha256 "c10c51306f21b167acab7f14576520e898c2dd150e8c8843dea13edcf8eb1665"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "26e90b07c06b079c668a74f773429d617a896d81fbaa3644ecd1ac43ce0dda64"
  end

  keg_only :versioned_formula
  depends_on "php"

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
