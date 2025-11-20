class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.sourceforge.io"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.83/Healpix_3.83_2024Nov13.tar.gz"
  version "3.83"
  sha256 "8876c18efc596fd706b2a004ac15f2fb60b795f2db6fbabea9d8ccf549531dda"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a3e9edaa26153b170f3a364e9248b3e852ecb5349f704865c94b30cf6959c28"
    sha256 cellar: :any,                 arm64_sequoia: "00a065c336cdb31ca6f06b99b478f0b287b63a4f1ded2042c3c73520e1fa683b"
    sha256 cellar: :any,                 arm64_sonoma:  "e1fee5370b52292ae8ac97fff082aa5556b77668a786ee8da2145131ea74095f"
    sha256 cellar: :any,                 arm64_ventura: "e1f000bb22bda5eaa5646998cc34accd8776a7f5dbc86bce1b84060268210c1e"
    sha256 cellar: :any,                 sonoma:        "43e79fede218b1b9a0c38a6b385d5eca84e3b641d5baffc0a0b08312712f5531"
    sha256 cellar: :any,                 ventura:       "982e2549856517eab2db91f0d842b9ee7a869f29e9b2651ac76444810325ef77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "709088c5a4b411ce2c24096ffe11fe947933eaa30dc253ccf44d4c95802a1a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ff195a45c8dad505f4db28341c4caa459228bd689cb68700ad0664210af5e7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "cfitsio"

  def install
    cd "src/C/autotools" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end

    cd "src/common_libraries/libsharp" do
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end

    cd "src/cxx" do
      ENV["SHARP_CFLAGS"] = "-I#{include}"
      ENV["SHARP_LIBS"] = "-L#{lib} -lsharp"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include <math.h>
      #include <stdio.h>
      #include "chealpix.h"
      int main(void) {
        long nside, npix, pp, ns1;
        nside = 1024;
        for (pp = 0; pp < 14; pp++) {
          nside = pow(2, pp);
          npix = nside2npix(nside);
          ns1  = npix2nside(npix);
        }
      };
    CPP

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
