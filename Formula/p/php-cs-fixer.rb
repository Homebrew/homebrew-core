class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.28.0/php-cs-fixer.phar"
  sha256 "e5d852e10ae8458f6d1864ac5d07f35b0e4e6d63b97c8a1cfa790e5290235254"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, ventura:        "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, monterey:       "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, big_sur:        "293f46415fff158e1d7dc6a99e0738ab251f1f653484ac713976c4922c107926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad2beaac222bb040de449f295a8056c4d411fedc37f9779e7f9887a7a43417b"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
