class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.5.0.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.5.0.tar.xz"
  sha256 "39cb6e4acd679b574d3d3276f148213e935fc25f90403eb84fb1b836a806ef1e"
  license "PHP-3.01"
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e206867f5162b5ffc490ad8a57d4c143c74ab3cbd2a0631faaaa41efc129747"
    sha256 cellar: :any,                 arm64_sequoia: "fb0ba265502cbd9cbd2f79d1e33c11c5ac300de65cdd0082e28bfe62654c5378"
    sha256 cellar: :any,                 arm64_sonoma:  "37a8c4be99a6143c813c1de31314f64cec944562c8f4866b98dce45be1014293"
    sha256 cellar: :any,                 sonoma:        "5b7c90aa8d1dedfa761dda0dcb49eea2ba837a3171d90d47095e8b807df9d9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77bc886ebcd05167960e812f45d1a35dd14925722f4d1258e9a17e65139d1ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a45121a45dcf66d6c128ac900ecc012d13694fa3f91145cdb89c98dd27ec7f"
  end

  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "php"

  def php
    # Always use matching PHP version
    Formula[name.sub("-intl", "")]
  end

  def install
    # Keep aligned with PHP formula
    extension_dir = Utils.safe_popen_read(php.bin/"php-config", "--extension-dir").chomp
    extension_dir = lib/"php/pecl"/File.basename(extension_dir)

    cd "ext/intl" do
      system "phpize"
      system "./configure"
      system "make"
      system "make", "install", "EXTENSION_DIR=#{extension_dir}"
    end
    rm(%w[NEWS README.md])

    # Automatically load extension on install and unload on uninstall or unlink
    (prefix/"etc/php/#{version.major_minor}/conf.d/ext-intl.ini").write <<~INI
      [intl]
      extension="#{extension_dir}/intl.so"
    INI
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php
      $formatter = new NumberFormatter('en_US', NumberFormatter::DECIMAL);
      echo $formatter->format(1234567), PHP_EOL;

      $formatter = new MessageFormatter('de_DE', '{0,number,#,###.##} MB');
      echo $formatter->format([12345.6789]);
      ?>
    PHP
    assert_equal "1,234,567\n12.345,68 MB", shell_output("#{php.bin}/php test.php")
    assert_match "intl", shell_output("#{php.bin}/php -m")
  end
end
