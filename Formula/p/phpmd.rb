class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.15.0/phpmd.phar"
  sha256 "6a28ef55de0c753b070d1d1580bb08a0d146016f89f0eddcef60ac4fc1083544"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5471e871a390181f97c13a9c2bc6e3c5a9be1a8d1854c6941c9000c0f3fbf8b"
  end

  depends_on "php"

  def install
    bin.install "phpmd.phar" => "phpmd"
  end

  test do
    (testpath/"src/HelloWorld/Greetings.php").write <<~EOS
      <?php
      namespace HelloWorld;
      class Greetings {
        public static function sayHelloWorld($name) {
          return 'HelloHomebrew';
        }
      }
    EOS

    assert_match "Avoid unused parameters such as '$name'.",
      shell_output("#{bin}/phpmd --ignore-violations-on-exit src/HelloWorld/Greetings.php text unusedcode")
  end
end
