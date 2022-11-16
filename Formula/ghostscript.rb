class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs1000/ghostpdl-10.0.0.tar.xz"
  sha256 "8f2b7941f60df694b4f5c029b739007f7c4e0d43858471ae481e319a967d5d8b"
  license "AGPL-3.0-or-later"

  # The GitHub tags omit delimiters (e.g. `gs9533` for version 9.53.3). The
  # `head` repository tags are formatted fine (e.g. `ghostpdl-9.53.3`) but a
  # version may be tagged before the release is available on GitHub, so we
  # check the version from the first-party website instead.
  livecheck do
    url "https://www.ghostscript.com/json/settings.json"
    regex(/["']GS_VER["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_ventura:  "a698c53fbc3a1117c204bf7e20122c3469cd46548f908bdf3c805b61a1620f66"
    sha256 arm64_monterey: "07becfb977ec79a7cdd2b6c5298fbb3d24ba61599106d903a7e1ea51d23b3df3"
    sha256 arm64_big_sur:  "6d71b98737f6113d18b963ca01d454e46218458b7b6eb8e2a5ae4c59359c5d30"
    sha256 ventura:        "b8a4f24fd3d10ef89a53af4d9793efde9b9ce019247a398614fcba87b6d6ec9f"
    sha256 monterey:       "c61d7421c9835d33d293fd0d496ce8fb983d8ee9351a6c59e3efbd621a4bec30"
    sha256 big_sur:        "eaf18fcce3a87ea2513439b58733a675c96a650ec91c4302293927e0054b43c6"
    sha256 catalina:       "0a200d59567de71739729720e96e9012961e1149c3a8cfe4ff79ca44b6a24a43"
    sha256 x86_64_linux:   "95c5e86cc3e8d68e61b7c7c7659aa75b6673d399f67e99ab815418d9f165ce22"
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
