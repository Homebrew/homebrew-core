class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://lrr.tvc-16.science"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.81.tar.gz"
  sha256 "d4ded2cde7d30b5d565da8a0f85014a245cefe9a8f969a45aa0eec57854beadc"
  license "MIT"
  revision 2
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f62766da149edf777c4c5c734aea4e3152e22537500693606e8912de3cc81c3d"
    sha256 cellar: :any, arm64_tahoe:       "3c6222e1f47a409b3a720132d321e71a037da604a2885683fa874da1488039b2"
    sha256 cellar: :any, arm64_sequoia:     "b725c11ca68431fcb7a2aa52880d8a25d91ea733a74ba9183fab4aeecf85c771"
    sha256 cellar: :any, arm64_linux:       "d9bbd2770777954bd13c882184b5a05aeb30b3196b242bfe27873cd2db45495d"
    sha256 cellar: :any, x86_64_linux:      "3d9ab1fd9c6e6f029d3e772b8616fa0f362d35a22da99d349e9a496708cdf20a"
  end

  depends_on "cpanminus" => :build
  depends_on "pkgconf" => :build

  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libffi" # TODO: uses_from_macos when node supports it
  depends_on "node"
  depends_on "openssl@4"
  depends_on "perl" # perl >= 5.36.0
  depends_on "redis" # TODO: migrate to `valkey`
  depends_on "zstd"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.2-3.tar.gz"
    sha256 "dc6ee21aed560d36f36be608909344bd2e25d63ab5d959553401e02f5df28a6b"

    livecheck do
      url :url
      regex(/href=.*?Image-Magick[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)\.t/i)
    end
  end

  # Temporary resource to patch
  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.96.tar.gz"
    sha256 "ab213691685fb2a576c669cbc8d9266f8165a31563ad15b7c4030b94adfc0753"

    # Backport support for OpenSSL 4.0
    patch do
      url "https://github.com/radiator-software/p5-net-ssleay/commit/a55abab4a33b040fbd56cc18fde6c257af2928e2.patch?full_index=1"
      sha256 "dd0fab47cfb05393ba1124f0b3fcbdf43cb346212ca145beed5aa8af9dfbd12d"
      type :backport
      resolves "https://github.com/radiator-software/p5-net-ssleay/pull/553"
    end
  end

  # The last stable release does not build with perl 5.44's stricter `xsubpp`
  # TODO: Remove this when the next release of this resource is out.
  resource "Sys::CpuAffinity" do
    url "https://cpan.metacpan.org/authors/id/M/MO/MOB/Sys-CpuAffinity-1.13_05.tar.gz"
    sha256 "cd5ac2f3e2dfd60c4eb8a6f8df04646337611caf24fdcfce5e026e01b492125f"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["OPENSSL_PREFIX"] = formula_opt_prefix("openssl@4")
    ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"] = formula_opt_lib("libarchive")/shared_library("libarchive")
    ENV["ALIEN_INSTALL_TYPE"] = "system"
    ENV["PERL_MM_USE_DEFAULT"] = "1"

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL",
                "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Net::SSLeay").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    resource("Sys::CpuAffinity").stage { system "cpanm", ".", "--notest", "-l", libexec }

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
