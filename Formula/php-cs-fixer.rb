class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.17.0/php-cs-fixer.phar"
  sha256 "ae3a832028cc19498ef35953380dac8c8bd8a42ee45fcc86be727fefab7839f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa935ac466a0cae488f5a6025dacf26b09c96c539b4ddddd24909ac24eb2194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fa935ac466a0cae488f5a6025dacf26b09c96c539b4ddddd24909ac24eb2194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fa935ac466a0cae488f5a6025dacf26b09c96c539b4ddddd24909ac24eb2194"
    sha256 cellar: :any_skip_relocation, ventura:        "0fa935ac466a0cae488f5a6025dacf26b09c96c539b4ddddd24909ac24eb2194"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa935ac466a0cae488f5a6025dacf26b09c96c539b4ddddd24909ac24eb2194"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fa935ac466a0cae488f5a6025dacf26b09c96c539b4ddddd24909ac24eb2194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088efc33496392564f15aaf486af77955c52816cc1e4e5245e321dff57dcfe51"
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
