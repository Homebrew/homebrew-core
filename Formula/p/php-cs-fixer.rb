class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.25.1/php-cs-fixer.phar"
  sha256 "cb0d89a37603d64360d97e42401093a4da15c220d633bfd1c4a1118e3e35e312"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a84014a2dccebfcbd448d56cd81c9211beb6dbd9e61c8d7ec87b5b1bc4ee6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a84014a2dccebfcbd448d56cd81c9211beb6dbd9e61c8d7ec87b5b1bc4ee6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74a84014a2dccebfcbd448d56cd81c9211beb6dbd9e61c8d7ec87b5b1bc4ee6a"
    sha256 cellar: :any_skip_relocation, ventura:        "74a84014a2dccebfcbd448d56cd81c9211beb6dbd9e61c8d7ec87b5b1bc4ee6a"
    sha256 cellar: :any_skip_relocation, monterey:       "74a84014a2dccebfcbd448d56cd81c9211beb6dbd9e61c8d7ec87b5b1bc4ee6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "74a84014a2dccebfcbd448d56cd81c9211beb6dbd9e61c8d7ec87b5b1bc4ee6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959363f59b3585b13d5874da5b685914abd5eb9c05d152f6ef2c333adba25979"
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
