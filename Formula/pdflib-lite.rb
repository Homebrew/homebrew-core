class PdflibLite < Formula
  desc "Subset of the functionality of PDFlib 7"
  homepage "https://www.pdflib.com/download/free-software/pdflib-lite-7/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/pdflib/PDFlib-Lite-7.0.5p3.tar.gz"
  mirror "https://fossies.org/linux/misc/old/PDFlib-Lite-7.0.5p3.tar.gz"
  version "7.0.5p3"
  sha256 "e5fb30678165d28b2bf066f78d5f5787e73a2a28d4902b63e3e07ce1678616c9"

  # PDFlib Lite reached its end of life in 2011 and is no longer supported.
  livecheck do
    skip "No longer supported"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 big_sur:      "7a20d3b5a63a817f98257a69ef4b12f2ec57136a82799bd8028ee4beba21a60e"
    sha256 cellar: :any,                 catalina:     "200edc8d498349fcebe26df1d692c4c8b7599055b6efadead3199356e9b750b8"
    sha256 cellar: :any,                 mojave:       "67334e52d81135fa1c1fbc5ff4065b745087d2072955b052aac6fad79520f663"
    sha256 cellar: :any,                 high_sierra:  "7a3783e63304556c7c93604449ac09718cca6ea4e2244ff5819edb2a5d99f8f7"
    sha256 cellar: :any,                 sierra:       "466701d2cac2d101b470fbdb122ba3a8f4f9169fe6a28fc8846859d8f7cfafc8"
    sha256 cellar: :any,                 el_capitan:   "c05f42bfb25d1fa204440a1d421af10f9bf853e94dd17c7325e0382d7683d589"
    sha256 cellar: :any,                 yosemite:     "e2e8891b33b4f3f2bab8f809e19d9df0450c1e872d39e6d5090094630210ee45"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c4db2641d4ddc42396974295f84950335aae983072a73240604be7f7e9f1e712"
  end

  def install
    # Without the following substitution, pdflib-lite runs into weird
    # build errors due to bad interactions with the TIFF headers.
    # This workaround comes from the MacPorts.org portfile for pdflib.
    ENV["CPPFLAGS"] = "-isystem#{prefix}"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-java",
                          "--without-perl",
                          "--without-py",
                          "--without-tcl",
                          "--without-ruby"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      pdflib-lite is not open source software; usage restrictions apply!
      Be sure to understand and obey the license terms, which can be found at:
      https://www.pdflib.com/download/free-software/pdflib-lite-7/pdflib-lite-licensing/
    EOS
  end
end
