class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.60.tar.gz"
  sha256 "27889a0b32b70ddfd2781b0c55d8924953baf879a55cf3bd54759902ea3fea49"
  license "MIT"
  revision 1
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfeddce6cf385603aacfd7e6f8575ec15f287bff42368fbd6750fcc2e73cab94"
    sha256 cellar: :any,                 arm64_sequoia: "cc74f3545f1c4bef7bee2be1c24430cd9c99dc68f5d019c2014570aa9c5b5e4c"
    sha256 cellar: :any,                 arm64_sonoma:  "8be2d798cfb4fcbf459f8b4ff7d363e5ceca3975314e2bb773f7a8e4643de5db"
    sha256 cellar: :any,                 sonoma:        "5258447053106cf0c9e7072f8a596a999be0e1ced876e5348b1b1c10e9dab074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed1140b6d3c63a5ea2f986e16cf7ed78b9eb95872a4f091d24657c80f1e7b034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062e2b9bc86d06ab91ba517c8b039762e8e26883a660c13264adf53e6f7a6c27"
  end

  depends_on "pkgconf" => :build

  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis" # TODO: migrate to `valkey`
  depends_on "zstd"

  uses_from_macos "libffi"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.1-28.tar.gz"
    sha256 "bc54137346c1d45626e7075015f7d1dae813394af885457499f54878cfc19e0b"
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
