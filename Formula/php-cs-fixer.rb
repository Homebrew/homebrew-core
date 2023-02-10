class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.2 on the next release, if possible.
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.14.4/php-cs-fixer.phar"
  sha256 "c0a023616e6cac6286bb478247ee63e070e5f31a0a0c85bf23e8720a9668f142"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29a80b9fe1c17aadd7742f4943eaab422bf16c216c7b6d678f79f0114afad9e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29a80b9fe1c17aadd7742f4943eaab422bf16c216c7b6d678f79f0114afad9e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29a80b9fe1c17aadd7742f4943eaab422bf16c216c7b6d678f79f0114afad9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "29a80b9fe1c17aadd7742f4943eaab422bf16c216c7b6d678f79f0114afad9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "29a80b9fe1c17aadd7742f4943eaab422bf16c216c7b6d678f79f0114afad9e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "29a80b9fe1c17aadd7742f4943eaab422bf16c216c7b6d678f79f0114afad9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be3a49bb7ad7e96718c5b543eacba3fc5ba73a07696520cec8e07c010792ac3"
  end

  depends_on "php@8.1"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.1"].opt_bin}/php
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

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
