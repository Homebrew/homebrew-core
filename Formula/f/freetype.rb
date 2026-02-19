class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.1/freetype-2.14.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.1.tar.xz"
  sha256 "32427e8c471ac095853212a37aef816c60b42052d4d9e48230bab3bdf2936ccc"
  license "FTL"
  revision 2

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a070535b10bad60b85121da482ae0dc4ce51aea9d5fd9b3f1e6aca82cb3dd89d"
    sha256 cellar: :any,                 arm64_sequoia: "41845ef36d7a23a1cb6191ff6b82735c43fa44098299e2bc573458e9e9eb0e86"
    sha256 cellar: :any,                 arm64_sonoma:  "78eb5dab07bc140d9551abe2c5daa993009ad339f0f8864ac11d566facb59142"
    sha256 cellar: :any,                 sonoma:        "0ee5ee9e238cf951997283d2db0b17206841b1c578d0ce812fc16fef066449bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da8e6cc37b1b2dd321e7ec6090193db6c162cb0a3385a024715a17aa34ac5777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76ba9fbe1c48345c90208187d4ddec0913331d67d71ce8d0248467eefc9d8b2"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # https://gitlab.freedesktop.org/freetype/freetype/-/issues/1358
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin" if OS.mac?

    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
