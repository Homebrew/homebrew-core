class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.19.3/php-cs-fixer.phar"
  sha256 "64238c2940e273f6182abe5279fea0df3707ac3d18f30909f0ab4fb6f9018f94"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55e00c9bf800348c73ec404b416b749b35a9a608a4f68380b8a1cb66005832d7"
  end

  keg_only :versioned_formula
  depends_on "php@8.0"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.0"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
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
