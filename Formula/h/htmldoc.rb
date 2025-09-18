class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/refs/tags/v1.9.21.tar.gz"
  sha256 "9f783917c7f6a23997c6318c807435aa41445a8a315e83cb327c23db4b8af918"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6d2f5d7a5c195e9d5db172d5abc4a7bccfcfcf6c6f9554c4750dfa61d9d7d6ac"
    sha256 arm64_sequoia: "992b9f29499ac797cd22508ba41bde0719b774ec97a5a896739553cb3c9f76bf"
    sha256 arm64_sonoma:  "f139e9c021668d078160b6d3e70027de48d7431e7e2a9f25c0953783c816e6fd"
    sha256 sonoma:        "7de501ff53dfefa059fe0a4de2f5a572ee4a8d9d05fcd380c9f6dc039eb157f5"
    sha256 arm64_linux:   "2220f561b4b1c854d2a95a3f87a96a27e66370c39179c3ea4245f6cc59490cd7"
    sha256 x86_64_linux:  "fbff825c6e010dbf322e3299d48336ac6196990667e8a6024ce1e73842873afa"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", "--mandir=#{man}",
                          "--without-gui",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"htmldoc", "--version"
  end
end
