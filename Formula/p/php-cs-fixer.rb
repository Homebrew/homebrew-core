class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.62.0/php-cs-fixer.phar"
  sha256 "67f90074a21f99407d77cac3a365cd795d5180b3c5e4b64ca38ae78d4a2a4d5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd029f8edd0653f86e9fc6c270aecffd76cde4130dc292b634536cda4bd8e2cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd029f8edd0653f86e9fc6c270aecffd76cde4130dc292b634536cda4bd8e2cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd029f8edd0653f86e9fc6c270aecffd76cde4130dc292b634536cda4bd8e2cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd029f8edd0653f86e9fc6c270aecffd76cde4130dc292b634536cda4bd8e2cb"
    sha256 cellar: :any_skip_relocation, ventura:        "dd029f8edd0653f86e9fc6c270aecffd76cde4130dc292b634536cda4bd8e2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "dd029f8edd0653f86e9fc6c270aecffd76cde4130dc292b634536cda4bd8e2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b29e792e6cb63944e7a2627d4b04df3d3ce544239729f6728082dc7eb989b68"
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
