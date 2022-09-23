class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs1000/ghostpdl-10.0.0.tar.xz"
  sha256 "8f2b7941f60df694b4f5c029b739007f7c4e0d43858471ae481e319a967d5d8b"
  license "AGPL-3.0-or-later"

  # We check the tags from the `head` repository because the GitHub tags are
  # formatted ambiguously, like `gs9533` (corresponding to version 9.53.3).
  livecheck do
    url :head
    regex(/^ghostpdl[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "c84daf7a848fac53bf2968239151361290ccb277accae6f11b0b39a7acb5f914"
    sha256 arm64_big_sur:  "a4f21885ac9b57f6e5511a1208b9d36ad0aa473180a2e080a9b4c23de2a5b6e9"
    sha256 monterey:       "38729b0c92a70014d82ddd57d33190019822f999efdb69d3f95e2e4cbe38fb71"
    sha256 big_sur:        "d1c4c864b2c954cf10c9023b5468652f60fb943d5ba91c190a85ef9d8224571f"
    sha256 catalina:       "335d57520e942b8547d79f62b505cc87a8afee12ecc50baccebe9dad32a0f0d0"
    sha256 x86_64_linux:   "478b2bb55a41d3afbfbdf55956180e6f653a981219dd137ba5728fbce8bed6ea"
  end

  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "https://git.ghostscript.com/ghostpdl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openjpeg"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  # fmemopen is only supported from 10.13 onwards (https://news.ycombinator.com/item?id=25968777).
  # For earlier versions of MacOS, needs to be excluded.
  # This should be removed once patch added to next release of leptonica (which is incorporated by ghostscript in
  # tarballs).
  patch do
    url "https://github.com/DanBloomberg/leptonica/commit/848df62ff7ad06965dd77ac556da1b2878e5e575.patch?full_index=1"
    sha256 "7de1c4e596aad5c3d2628b309cea1e4fc1ff65e9c255fe64de1922b3fd2d60fc"
    directory "leptonica"
  end

  def install
    # Delete local vendored sources so build uses system dependencies
    libs = %w[expat freetype jbig2dec jpeg lcms2mt libpng openjpeg tiff zlib]
    libs.each { |l| (buildpath/l).rmtree }

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args,
                      "--disable-compile-inits",
                      "--disable-cups",
                      "--disable-gtk",
                      "--with-system-libtiff",
                      "--without-x"

    # Install binaries and libraries
    system "make", "install"
    ENV.deparallelize { system "make", "install-so" }

    (pkgshare/"fonts").install resource("fonts")
    (man/"de").rmtree
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match "Hello World!", shell_output("#{bin}/ps2ascii #{ps}")
  end
end
