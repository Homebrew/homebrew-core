class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.4.15.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.4.15.tar.xz"
  sha256 "a060684f614b8344f9b34c334b6ba8db1177555997edb5b1aceab0a4b807da7e"
  license "PHP-3.01"
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26b8af2580ca7892c69d67898e660d61b63e13fefc48c44a11f6f1a056c3518e"
    sha256 cellar: :any,                 arm64_sequoia: "2ec1502d5b14aa65a13ab4ed3823485c8f882c98d941fb6ec970a0b55da68e8a"
    sha256 cellar: :any,                 arm64_sonoma:  "608c9e12fa12fadff0eee98580c696d4be9e46bb5fc29fed69386557d49bd80f"
    sha256 cellar: :any,                 sonoma:        "55b24a673e7a460dde5432c31f655b0070f62b4ce8acee62bb887935ee25fef9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20781f73530f2d366d1c39f36fd9442da7c8f9a9b77c55cb6c377cb01e1113f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0017171e8db0e012330b5efb895b2a6573983f12043c7a64776f73bfa31aaa18"
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
