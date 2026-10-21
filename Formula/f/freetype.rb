class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.15.0/freetype-2.15.0.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.15.0.tar.xz"
  sha256 "93cd47eb719c325107f2d3cf087d06299e944c3b48a40b55537302304dea1dd5"
  license "FTL"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e95cd1f10672199f21f824b4f8a848c3a4f733df2fcd6e3d88b08446131eeed3"
    sha256 cellar: :any, arm64_tahoe:       "75125d33e1fa0ea106b138e0458aba3054abd86ad7fbadd86ee4ed81fc8a2174"
    sha256 cellar: :any, arm64_sequoia:     "7e7a7bb07a484cf6fccb168587d697ed24b98cce52e6ac735debb22adb422237"
    sha256 cellar: :any, arm64_linux:       "da5494c91d3d359701c6af3bb2c0c3525aa512d1f90fee0fd915c92497b5387d"
    sha256 cellar: :any, x86_64_linux:      "0f637083d41afca2d7b9b8aae297fc08583897b4659b170f5495f96bdf696c11"
  end

  depends_on "pkgconf" => :build
  depends_on "brotli"
  depends_on "libpng"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--with-brotli",
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
