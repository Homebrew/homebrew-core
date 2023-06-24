class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.19.0/php-cs-fixer.phar"
  sha256 "af2efddfe2ab4d85010eb2664d59449be36306ba4aa2452fe2e6b0d856a4eda3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c5c69679227d26cfe2f98e93242c447715eb80ec67641bd63532428901ee823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5c69679227d26cfe2f98e93242c447715eb80ec67641bd63532428901ee823"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c5c69679227d26cfe2f98e93242c447715eb80ec67641bd63532428901ee823"
    sha256 cellar: :any_skip_relocation, ventura:        "5c5c69679227d26cfe2f98e93242c447715eb80ec67641bd63532428901ee823"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5c69679227d26cfe2f98e93242c447715eb80ec67641bd63532428901ee823"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c5c69679227d26cfe2f98e93242c447715eb80ec67641bd63532428901ee823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84cdd9a7f0df7b207755df6d5ba62a15d40e9f50cc90fb002f39e0d9ba829607"
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
