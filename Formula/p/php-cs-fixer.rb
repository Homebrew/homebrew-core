class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.34.1/php-cs-fixer.phar"
  sha256 "c15a8620d0ef56bd754036a6a354879a4c0ab83aaef0644314136c9370bb9adf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ee1ae8a6bffd7c0b52b3c780e9293f916a0d48e46d8e30667562e4665f818ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee1ae8a6bffd7c0b52b3c780e9293f916a0d48e46d8e30667562e4665f818ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ee1ae8a6bffd7c0b52b3c780e9293f916a0d48e46d8e30667562e4665f818ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ee1ae8a6bffd7c0b52b3c780e9293f916a0d48e46d8e30667562e4665f818ab"
    sha256 cellar: :any_skip_relocation, ventura:        "3ee1ae8a6bffd7c0b52b3c780e9293f916a0d48e46d8e30667562e4665f818ab"
    sha256 cellar: :any_skip_relocation, monterey:       "3ee1ae8a6bffd7c0b52b3c780e9293f916a0d48e46d8e30667562e4665f818ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2aa163a81a3c1c78e3074b260304fc11ead612119318b72d321ab356eda7ae"
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
