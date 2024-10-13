class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.21.tar.gz"
  sha256 "ed2d704d058389eb4c97d62080c64fa96fcc230be663ec8958f35764d229c463"
  license "MIT"
  revision 2
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32b94989e04f1bc1643bf9ac3fd53798e660f0e3988d9482782648e29a9a144d"
    sha256 cellar: :any,                 arm64_sonoma:  "007d0eb316f50682547e931268e501db9c9f70bead21f98901e3f67a7e90c271"
    sha256 cellar: :any,                 arm64_ventura: "f1b0826609df1a9aa730ee2ba788432855112786b0b897d002c85d9b1a3991e6"
    sha256 cellar: :any,                 sonoma:        "e3e9780e0a10edd57708c134759e6760ad42868ec0bca0f2e563bf2b1986a55c"
    sha256 cellar: :any,                 ventura:       "162dd99fdbae029248a39482b69c83afede408fa7d5058557c1cd03b1012fd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dbae601b895428500313e9c4851fafb8e5edd3c94278b2b7d37639a141bb5a6"
  end

  depends_on "nettle" => :build
  depends_on "pkg-config" => :build

  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "giflib"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis"
  depends_on "zstd"

  uses_from_macos "libffi"

  on_macos do
    depends_on "libb2"
    depends_on "lz4"
    depends_on "lzo"
  end

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.1-28.tar.gz"
    sha256 "bc54137346c1d45626e7075015f7d1dae813394af885457499f54878cfc19e0b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV.append_to_cflags "-I#{Formula["libarchive"].opt_include}"
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

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *std_npm_args(prefix: false)
    system "perl", "./tools/install.pl", "install-full"

    prefix.install "README.md"
    (libexec/"lib").install Dir["lib/*"]
    libexec.install "script", "package.json", "public", "templates", "tests", "lrr.conf"
    cd "tools/build/homebrew" do
      bin.install "lanraragi"
      libexec.install "redis.conf"
    end

    return if OS.linux? || Hardware::CPU.intel?

    # FIXME: This installs its own `libarchive`, but we should use our own to begin with.
    #        As a workaround, install symlinks to our `libarchive` instead of the downloaded ones.
    libarchive_install_dir = libexec/"lib/perl5/darwin-thread-multi-2level/auto/share/dist/Alien-Libarchive3/dynamic"
    libarchive_install_dir.children.map(&:unlink)
    ln_sf Formula["libarchive"].opt_lib.children, libarchive_install_dir
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
