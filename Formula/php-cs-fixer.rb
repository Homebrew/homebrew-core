class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.22.0/php-cs-fixer.phar"
  sha256 "88fe5d98991867f1354c09b8a0b382090e4309ce3e23709c12bf2d39ecf30ade"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5555951036af7394c3b874e915b7aa8eeb8740b3b5673d5e69b66b0d76c13aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5555951036af7394c3b874e915b7aa8eeb8740b3b5673d5e69b66b0d76c13aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5555951036af7394c3b874e915b7aa8eeb8740b3b5673d5e69b66b0d76c13aa"
    sha256 cellar: :any_skip_relocation, ventura:        "a5555951036af7394c3b874e915b7aa8eeb8740b3b5673d5e69b66b0d76c13aa"
    sha256 cellar: :any_skip_relocation, monterey:       "a5555951036af7394c3b874e915b7aa8eeb8740b3b5673d5e69b66b0d76c13aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5555951036af7394c3b874e915b7aa8eeb8740b3b5673d5e69b66b0d76c13aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d373d9c718bcdcf1042fe6a7bc71c4125b9216b4ade68135c12586a96581100"
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
