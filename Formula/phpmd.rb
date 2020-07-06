class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.8.2/phpmd.phar"
  sha256 "0b531cbbc18a26115eede06077d5670e1f4fd0a8545d7fe547adf068fb7f18c5"
  license "BSD-3-Clause"

  bottle :unneeded

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

    assert_match /Avoid unused parameters such as '\$name'\.$/,
      shell_output("#{bin}/phpmd --ignore-violations-on-exit src/HelloWorld/Greetings.php text unusedcode")
  end
end
