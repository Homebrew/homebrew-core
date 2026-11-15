class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.25/htmldoc-1.9.25-source.zip"
  sha256 "ffcc8b015eb2b84ee7c99a4c35504b695b6c4994ad0395d00ee458ebf259f338"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "a5671cedaad53dcaf702bed77192b62fb310592bb47e8b28529f15404b87b9f3"
    sha256 arm64_tahoe:       "728772581167872430766dcd23ef396b62b1bdf3af60a51c0342f510e67fb560"
    sha256 arm64_sequoia:     "f44cd8e1733a2c85afd2e7d7b9da8a00de294289416b12f22e504802b32f169d"
    sha256 arm64_linux:       "304e6916c3f765440cc991d7c76fb17c19393138c7a8e802cd372bee2b6f3d00"
    sha256 x86_64_linux:      "1f31b1d98f9e5d70a765d8507d24555ebfb074cf04edc8933f7917337ba698aa"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", "--without-gui", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"htmldoc", "--version"
  end
end
