class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.14.1/phpmd.phar"
  sha256 "0b9543b341b6d44c9456595d834e5c6eb4981b8fdf934d55284ec4abfcce0eef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3852bcc7b7dbcde1dc29281cd24c116341328fa83fe5052f1146d825dae161b4"
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
