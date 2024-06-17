class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.59.3/php-cs-fixer.phar"
  sha256 "771950c9a65d1b87c451c2b83606b00e1996d514ec5c3c936f301b9dd5793bf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d345519d859907e9882d612642baca87ec8d4c5a84ce7ae8fe52cdb18e952f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d345519d859907e9882d612642baca87ec8d4c5a84ce7ae8fe52cdb18e952f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d345519d859907e9882d612642baca87ec8d4c5a84ce7ae8fe52cdb18e952f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d345519d859907e9882d612642baca87ec8d4c5a84ce7ae8fe52cdb18e952f1"
    sha256 cellar: :any_skip_relocation, ventura:        "2d345519d859907e9882d612642baca87ec8d4c5a84ce7ae8fe52cdb18e952f1"
    sha256 cellar: :any_skip_relocation, monterey:       "2d345519d859907e9882d612642baca87ec8d4c5a84ce7ae8fe52cdb18e952f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff928b904b3213acafc0d1724d070f18d2fb1ee2ec9e002a60b8384b350425c"
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
