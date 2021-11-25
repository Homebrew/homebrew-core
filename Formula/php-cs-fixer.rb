class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "12d4109a589c730f34591862d016eb058432a010e7f125a4f5be7efb5ffff9c3"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9979da8cbb781fd78fd4a79d36a4be3fd0b8e2bbdff1e89b66e930a0452f0eb"
  end

  depends_on "composer" => :build
  depends_on "php"

  def install
    system "composer", "config", "platform.php", Formula["php"].version.to_s
    system "composer", "update"

    inreplace "php-cs-fixer", "#!/usr/bin/env php", "#!#{Formula["php"].opt_bin}/php"

    prefix.install Dir["*"]

    bin.install_symlink prefix/"php-cs-fixer"
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
