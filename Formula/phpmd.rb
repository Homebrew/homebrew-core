class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.10.2/phpmd.phar"
  sha256 "5d16d2571ed029ce94a8dfcec2f50a280f9c896a1454eb93014474841861aa01"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ed3d4023ff0e8fef0b07b838d75f40f42ae3f61f531a47abdb9a100dce84705"
  end

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
