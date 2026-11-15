class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://lrr.tvc-16.science"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.82.tar.gz"
  sha256 "e511e963d419469a7a296495d06c54541916efb922369b409f314600723e7bd7"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae5814f7682f09d56a959240ae2735020663e7d8150e78ade9de9e4856953ff0"
    sha256 cellar: :any, arm64_tahoe:       "2de337f8f1fee018220b00b9bb7ed893077e2a3c98072c54593d6f39ed82324d"
    sha256 cellar: :any, arm64_sequoia:     "c5ca26be8154bc0725b185e5327589c0c6b9106d81c47fb913721493d63a3ac9"
    sha256 cellar: :any, arm64_linux:       "72c765c0d1e67b04e10f5a90565fe4d26f1bede21706f319c4f5e9a4e7f52dd4"
    sha256 cellar: :any, x86_64_linux:      "ae5bb1dda8b0627be5b6e7eb6af0ac4b872139b122f7a074e3388b483d592a77"
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
