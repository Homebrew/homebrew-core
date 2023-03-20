class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.15.1/php-cs-fixer.phar"
  sha256 "207bf806055f2dbdf559b6a2e97c3999c981f603dd193b51428bc2272ca94a5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d48c385739512a40e0869076df86ccd3163f5e192357c2096db152e1069d33a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d48c385739512a40e0869076df86ccd3163f5e192357c2096db152e1069d33a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d48c385739512a40e0869076df86ccd3163f5e192357c2096db152e1069d33a0"
    sha256 cellar: :any_skip_relocation, ventura:        "d48c385739512a40e0869076df86ccd3163f5e192357c2096db152e1069d33a0"
    sha256 cellar: :any_skip_relocation, monterey:       "d48c385739512a40e0869076df86ccd3163f5e192357c2096db152e1069d33a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d48c385739512a40e0869076df86ccd3163f5e192357c2096db152e1069d33a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade0a0e546fab844209678be7354beee04efd687f7e7e4031235b4b0ff45cf8e"
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
