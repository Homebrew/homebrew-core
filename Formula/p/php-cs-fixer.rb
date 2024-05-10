class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.56.1/php-cs-fixer.phar"
  sha256 "3ceb8efb42d3284b3f450c261efe6d8ac769054975dc2d8a975f2ba598d6edff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25c5522d25be8c1d482f8471e40c9cdd08d1b6dfb19ede5713529180d127282e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "674af323c56291127a5bc8752d844279bc50122adb5146b09d1f4fa790480063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef342278abf1a5753add10816c6a81092cc8f2e90ecd34b86a7f4b617894004"
    sha256 cellar: :any_skip_relocation, sonoma:         "fee2793fddd91f32098e324ba198dbc2c0d56c7997f4128c44e3dbfebd600e68"
    sha256 cellar: :any_skip_relocation, ventura:        "2308539308fc9bd7ffb03416e961b6c520f333ec0c801caa6acb529afe23edeb"
    sha256 cellar: :any_skip_relocation, monterey:       "700d284371bb748f0d4e697c648f183b3eb650a5baf7823230a41faf98951f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a098a6da97f3945bac748b59bcf3573bc8ebc076bb91553902f62e0fe61095cf"
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
