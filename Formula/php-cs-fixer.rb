class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.1.0/php-cs-fixer.phar"
  sha256 "e2cb82356feae90eafe9aebc9491957fc0ee96cacc77381db05f4673fe2f7a24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62b2f978a9b90740712983a5891dc1c7843f9b3b18a05a62ff7c17b5728db44f"
  end

  uses_from_macos "php", since: :mojave

  def install
    bin.install "php-cs-fixer.phar" => "php-cs-fixer"
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
