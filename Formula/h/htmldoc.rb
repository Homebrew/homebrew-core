class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.24/htmldoc-1.9.24-source.zip"
  sha256 "1ae2803f82a4fac7b4f8f80f036d82fdca8f467fb89f4df5d07e7889192e678f"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "20ad7960ef43ece66682c401f56b4c88c0890ea708c39ac7315ebc53ab87a00f"
    sha256 arm64_tahoe:       "6631c9548f14102d2166d93ced7c0e9a273775d04eadd0be8e2abeb0b7edf954"
    sha256 arm64_sequoia:     "cb7fb97ee35b5403b1f719d71536a04434635235eecf2a06b6db54cd63c7a1a1"
    sha256 arm64_sonoma:      "4620f604ca23d9458023d2184573b4876fe715aa8877c01fef8647e8d085e5a9"
    sha256 arm64_linux:       "626a826c03ddece8c6fea5778fbde852b46230566e75243b7770f24690cb1658"
    sha256 x86_64_linux:      "7aebfbd117c656e7a82785909a2d782bc7da1c378522a3d880e2e3e4b6ea4b75"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--without-gui", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"htmldoc", "--version"
  end
end
