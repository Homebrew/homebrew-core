class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://static.phpmd.org/php/2.6.0/phpmd.phar"
  sha256 "69bec1176370a3bcbb81e1d422253f70305432ecf5b2c50d04ec33adb0e20f7a"

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

    assert_match /Avoid unused parameters such as '\$name'\.$/, shell_output("#{bin}/phpmd --ignore-violations-on-exit src/HelloWorld/Greetings.php text unusedcode")
  end
end
