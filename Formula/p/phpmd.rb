class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.15.0/phpmd.phar"
  sha256 "6a28ef55de0c753b070d1d1580bb08a0d146016f89f0eddcef60ac4fc1083544"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "28cd360f0eea58782927875c91b4d709764ae46076f79d88681e2fcb73cf041e"
  end

  # Upstream does not support Phar download anymore, see https://github.com/phpmd/phpmd/issues/971
  deprecate! date: "2024-10-18", because: :unsupported
  disable! date: "2025-10-18", because: :unsupported

  depends_on "php"

  def install
    bin.install "phpmd.phar" => "phpmd"
  end

  test do
    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php
      namespace HelloWorld;
      class Greetings {
        public static function sayHelloWorld($name) {
          return 'HelloHomebrew';
        }
      }
    PHP

    assert_match "Avoid unused parameters such as '$name'.",
      shell_output("#{bin}/phpmd --ignore-violations-on-exit src/HelloWorld/Greetings.php text unusedcode")
  end
end
