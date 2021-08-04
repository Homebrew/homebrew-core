class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.0.2/php-cs-fixer.phar"
  sha256 "b537c19425b0e638c2bebcffee84eeed5670b29ebbb44219d7b675a5c2f7088d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55ad84360d69308bb45ef97379294f8bc8baff1dd0eec59adf97800448503c28"
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
