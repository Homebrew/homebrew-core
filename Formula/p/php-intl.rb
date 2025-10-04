class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.4.13.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.4.13.tar.xz"
  sha256 "b4f27adf30bcf262eacf93c78250dd811980f20f3b90d79a3dc11248681842df"
  license "PHP-3.01"
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d32a9dfb4a8fbc324b4587a84c94ff5553eae2206be238684651383db2ad05a8"
    sha256 cellar: :any,                 arm64_sequoia: "f75a89b23563162140329ca7c4603beaecb98be244c2824e2fcd6609094468c9"
    sha256 cellar: :any,                 arm64_sonoma:  "150dde154111fc7a0d9d1f74550aecd52f16d57707f95372169b227ae85f673c"
    sha256 cellar: :any,                 sonoma:        "e2b532334da5baace1950693642c040bb7da168075f4ef4bd90a4e46695ea68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ded715bb1aa2fbae374d20ff45c6ecf31430d5a9c6548addb1dea59ce26db92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9443e1c15177764007e4d054956a68640f83b5d7f90890aecf089f1dab9dddd3"
  end

  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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
