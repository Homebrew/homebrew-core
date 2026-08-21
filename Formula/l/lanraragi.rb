class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://lrr.tvc-16.science"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.81.tar.gz"
  sha256 "d4ded2cde7d30b5d565da8a0f85014a245cefe9a8f969a45aa0eec57854beadc"
  license "MIT"
  revision 1
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "02cbfef2afa717a23561d235b8dce37fe3cd30a5241319feec8e7bd14bafdd8e"
    sha256 cellar: :any, arm64_sequoia: "aa264163195fa4b019be99e155468a69856996b4904dc28885da9f3dcf47ce10"
    sha256 cellar: :any, arm64_sonoma:  "855f4ba8df233db48991edab679a1bd8f293f8ca5f9da762809725e137c71f74"
    sha256 cellar: :any, sonoma:        "16633e3eae9473433674819bd6bc944712043b99acea860c1d8c98196dcd17d9"
    sha256 cellar: :any, arm64_linux:   "ac4d358b763fb0eaaac350aa66844bc409744351669c080d91c4bf7548e2e9f9"
    sha256 cellar: :any, x86_64_linux:  "241b3853dd472045b0e99bac8057bef50c2a16e7c554c00a2e341ed80cf30866"
  end

  depends_on "cpanminus" => :build
  depends_on "pkgconf" => :build

  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libffi" # TODO: uses_from_macos when node supports it
  depends_on "node"
  depends_on "openssl@3"
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

  # The last stable release does not build with perl 5.44's stricter `xsubpp`
  # TODO: Remove this when the next release of this resource is out.
  resource "Sys::CpuAffinity" do
    url "https://cpan.metacpan.org/authors/id/M/MO/MOB/Sys-CpuAffinity-1.13_05.tar.gz"
    sha256 "cd5ac2f3e2dfd60c4eb8a6f8df04646337611caf24fdcfce5e026e01b492125f"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["OPENSSL_PREFIX"] = formula_opt_prefix("openssl@3")
    ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"] = formula_opt_lib("libarchive")/shared_library("libarchive")
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
