class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.70.tar.gz"
  sha256 "bc89ae47873a35145a0db5a4d93d274b89e7f546deaa396d389fe7975693f7a6"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4f86576d118a1637ce0782199448d27fe6c1c1b85b5f677a28a00ac0d74291a3"
    sha256 cellar: :any,                 arm64_sequoia: "3c0184197fa965de72895b6e47d0663160c41d8ae69750174e913cf31ad8fb6a"
    sha256 cellar: :any,                 arm64_sonoma:  "51082767fccba96f84b20bba75754f5739e242cb8180a5ca0af67d2c1d033829"
    sha256 cellar: :any,                 sonoma:        "1868bc4be55401b487271bcc1c0f9f7034721df9bec6454b4870f20ffb194937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce916c932637a2d482c9ef431e72bf6a008e957acb3cfec235abd4f607a0bb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf65e28832e61f3175af0122013761366850c4b5147255d202cbda3f402f1d38"
  end

  depends_on "cpanminus" => :build
  depends_on "pkgconf" => :build

  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl" # perl >= 5.36.0
  depends_on "redis" # TODO: migrate to `valkey`
  depends_on "zstd"

  uses_from_macos "libffi"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.2-3.tar.gz"
    sha256 "dc6ee21aed560d36f36be608909344bd2e25d63ab5d959553401e02f5df28a6b"

    livecheck do
      url :url
      regex(/href=.*?Image-Magick[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)\.t/i)
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix
    ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"] = Formula["libarchive"].opt_lib/shared_library("libarchive")
    ENV["ALIEN_INSTALL_TYPE"] = "system"

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL",
                "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *std_npm_args(prefix: false)
    system "perl", "./tools/install.pl", "install-full"

    # Modify Archive::Libarchive to help find brew `libarchive`. Although environment
    # variables like `ARCHIVE_LIBARCHIVE_LIB_DLL` and `FFI_CHECKLIB_PATH` exist,
    # it is difficult to guarantee every way of running (like `npm start`) uses them.
    inreplace libexec/"lib/perl5/Archive/Libarchive/Lib.pm",
              "$ENV{ARCHIVE_LIBARCHIVE_LIB_DLL}",
              "'#{ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"]}'"

    (libexec/"lib").install Dir["lib/*"]
    (libexec/"tools").install "tools/openapi.yaml"
    libexec.install "script", "package.json", "public", "locales", "templates", "tests", "lrr.conf"
    libexec.install "tools/build/homebrew/redis.conf"
    bin.install "tools/build/homebrew/lanraragi"
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
