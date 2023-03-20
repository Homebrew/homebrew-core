require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/v.0.8.90.tar.gz"
  sha256 "290bd2299962f14667a279dd8e40a1f93d1e9e338c08342af5830a1ce119c93e"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dd9f43321105969313ca666d7906cce798ac4120cbb8d3c0db4c9eba550bd32"
    sha256 cellar: :any,                 arm64_monterey: "2f126f77c83d76ec7d7f72fa287db55bf84f7e37fabe586335f89ba19fa47934"
    sha256 cellar: :any,                 arm64_big_sur:  "87a54c094ebb8307310643ccb794531510226b08fa885e22b8d861179fd68ae6"
    sha256 cellar: :any,                 ventura:        "b25da858f3a316fe59f18dba0a23e9ab388e9c55031fb1e785315a68586397f8"
    sha256 cellar: :any,                 monterey:       "9acd30fa0a98975762cd0127e117d5d5a6b8f3229601be9d0cbae54417b28345"
    sha256 cellar: :any,                 big_sur:        "dac62d7aa895ad2310b77dc7be80eaefaf48ec87d3a01536db7524d1fa4ea71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b1daae188327477fcb091c622a06797e6f502d37c8861f028d213e2a411b061"
  end

  depends_on "nettle" => :build
  depends_on "pkg-config" => :build
  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "giflib"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "perl"
  depends_on "redis"
  depends_on "zstd"

  uses_from_macos "libarchive"

  resource "libarchive-headers" do
    on_macos do
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
      sha256 "b422c37cc5f9ec876d927768745423ac3aae2d2a85686bc627b97e22d686930f"
    end
  end

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.0-0.tar.gz"
    sha256 "f90c975cbe21445777c40d19c17b7f79023d3064ef8fabcf348cf82654bc16eb"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", "#{libexec}/lib/perl5"
    ENV.prepend_path "PERL5LIB", "#{libexec}/lib"

    # On Linux, use the headers provided by the libarchive formula rather than the ones provided by Apple.
    ENV["CFLAGS"] = if OS.mac?
      "-I#{libexec}/include"
    else
      "-I#{Formula["libarchive"].opt_include}"
    end

    ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"
      end

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    if OS.mac?
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (libexec/"include").install "archive.h", "archive_entry.h"
        end
      end
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *Language::Node.local_npm_install_args
    system "perl", "./tools/install.pl", "install-full"

    prefix.install "README.md"
    (libexec/"lib").install Dir["lib/*"]
    libexec.install "script", "package.json", "public", "templates", "tests", "lrr.conf"
    cd "tools/build/homebrew" do
      bin.install "lanraragi"
      libexec.install "redis.conf"
    end
  end

  def caveats
    <<~EOS
      Automatic thumbnail generation will not work properly on macOS < 10.15 due to the bundled Libarchive being too old.
      Opening archives for reading will generate thumbnails normally.
    EOS
  end

  test do
    # Make sure lanraragi writes files to a path allowed by the sandbox
    ENV["LRR_LOG_DIRECTORY"] = ENV["LRR_TEMP_DIRECTORY"] = testpath
    %w[server.pid shinobu.pid minion.pid].each { |file| touch file }

    # Set PERL5LIB as we're not calling the launcher script
    ENV["PERL5LIB"] = libexec/"lib/perl5"

    # This can't have its _user-facing_ functionality tested in the `brew test`
    # environment because it needs Redis. It fails spectacularly tho with some
    # table flip emoji. So let's use those to confirm _some_ functionality.
    output = <<~EOS
      ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━!!!!!
      (╯・_>・）╯︵ ┻━┻
      It appears your Redis database is currently not running.
      The program will cease functioning now.
    EOS
    # Execute through npm to avoid starting a redis-server
    return_value = OS.mac? ? 61 : 111
    assert_match output, shell_output("npm start --prefix #{libexec}", return_value)
  end
end
