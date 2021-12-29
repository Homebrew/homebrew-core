class Phpmd < Formula
  desc "PHP Mess Detector"
  homepage "https://phpmd.org"
  url "https://github.com/phpmd/phpmd/releases/download/2.11.1/phpmd.phar"
  sha256 "57ce5e9a90114e411d3cd563b87cb2e814796481d3c3124b98a31fe79aeffe11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72e3ab34aff7457c79ba192d22d8b999329ebb17d7f5bbb98f05fe5476dec577"
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
