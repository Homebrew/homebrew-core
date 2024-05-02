require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  stable do
    url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.0.tar.gz"
    sha256 "76390a12c049216c708b522372a7eed9f2fcf8f8d462af107d881dbb1ce3a79f"

    # patch for `Can't load application from file ".../lanraragi": Can't open file "oshino"`
    # remove in next release
    patch do
      url "https://github.com/Difegue/LANraragi/commit/d2ab6807cc4b1ed1fe902c264cba7750ae07f435.patch?full_index=1"
      sha256 "3edc8e1248e5931bfc7f983af93b92354bb85368582d4ccedcd1af93013ce24a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b49498cbc0a34297dcb42c3afb77eebf5db20e38499ab7e35ebd0d985ec0f93"
    sha256 cellar: :any,                 arm64_ventura:  "6746c926ae28a5ea67e5c7d0640f63ae654435777914c267d64054733cc0b292"
    sha256 cellar: :any,                 arm64_monterey: "a76240c2c099dc3c87bb6496f5db3fa98fab445561faf27c3245e1a894fb672e"
    sha256 cellar: :any,                 sonoma:         "0aefa14f2fe76f790aa9a13c815256c3ca43fc1b1f8d670b468b0e9b766fbf13"
    sha256 cellar: :any,                 ventura:        "47e34ca1d4ed8ac217df7be95533f540b0fba4912b0220e70e52a8b7ecd26969"
    sha256 cellar: :any,                 monterey:       "e169e620e4eef0d430a227e4a8e4903946246d271a0133fdbf872d88aec8cea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b8ccd9a2cfeb25225e21ff477852767f99befcd3c6315e9ade1a34e43c3c376"
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
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis"
  depends_on "zstd"

  uses_from_macos "libarchive"

  resource "libarchive-headers" do
    on_macos do
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-121.tar.gz"
      sha256 "f38736ffdbf9005726bdc126e68ff34ddaee25326ae51d58e4385de717bc773f"
    end
  end

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.1-20.tar.gz"
    sha256 "a0c0305d0071b95d8580f1c18548beb683453d59d12cd8d9a9d3f6abe922ea38"
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

    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

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
