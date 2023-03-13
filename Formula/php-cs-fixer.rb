class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.15.0/php-cs-fixer.phar"
  sha256 "cd7b675680c8365b67742c77e62b92996e8f3439d314a306ffed86c7a2d6bf1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b7cb3119011704035b2d409790031e4fd6ee619a6ff6e54d1cf3d175fdd8e80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "072dba785152e5e142ace971e7ac2a25739097ba9e5476dc035f0a3e955b5354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71b2b23e213d87609b06eefaed356c60f259e9107deb9591d27fff4ad2ece361"
    sha256 cellar: :any_skip_relocation, ventura:        "c323394cdcb577b49a4695b93ebeb1efc47975b04a2682bad2e2efc0d57067eb"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c8ed09b634acfdf89e9dee99b47f364d791aee74dd2ed6536d38941eca6b82"
    sha256 cellar: :any_skip_relocation, big_sur:        "a670d6a3f91f6c174e209e3acc3ab9e1234d5bd148ffef58f9231b4dfd1d619f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78eff6f4d8ae00266717f8d7b909e6f02e3e898a0892c151cfbaf6c7f573ba9"
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
