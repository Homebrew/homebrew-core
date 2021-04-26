class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.10.0/phpmd.phar"
  sha256 "324e9423b9c6a70566f65870a63e6e5822ab3fa8978e1d1f7b337f0175eaef88"
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

    assert_match "Avoid unused parameters such as '$name'.",
      shell_output("#{bin}/phpmd --ignore-violations-on-exit src/HelloWorld/Greetings.php text unusedcode")
  end
end
