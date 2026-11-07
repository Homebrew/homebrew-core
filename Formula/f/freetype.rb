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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "14bc1768b07e0c28391877d3ead21f66f76fd70fea699ad996a693c01a5f660f"
    sha256 cellar: :any, arm64_tahoe:       "ebd689edade12b47b19101a31ee018dc6c156b0f4fb2f852741c0c44fbf99fd0"
    sha256 cellar: :any, arm64_sequoia:     "74ee3577ff475f019e379070f89dca205e9d90742fe18623722ea455482a4d05"
    sha256 cellar: :any, arm64_linux:       "ba8302f77365b87d28b3863f220b18a008dea8b99056d130696f62f0df861b1d"
    sha256 cellar: :any, x86_64_linux:      "5d26870c73d88cba6bb55b200d4156a9eb24c8ad4ef9cff547cf0da65163a2f9"
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
    # Avoid enabling macOS 15.4+ hvf feature for bottle compatibility
    ENV["ac_cv_header_hvf_Scaler_h"] = "no" if OS.mac? && MacOS.version <= :sequoia

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
