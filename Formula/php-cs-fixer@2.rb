class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "32c63d1c8cb34a9683958721cf2a9eee2f6231e541758641f416091c9bf650aa"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62f0ceae3aec334450704706f22b62d66dc966347a4a7c3324566e530746ffea"
  end

  keg_only :versioned_formula
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
      <?php $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
