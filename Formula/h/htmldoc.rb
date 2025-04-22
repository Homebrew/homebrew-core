class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/refs/tags/v1.9.20.tar.gz"
  sha256 "a155c86c69f90a426ff7244bd046bad026cc5ba9ac2be89dcb1d7973c52d5d82"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "5183e094ab3128b038025333172df99251d2a4f1db6c409d892eba9ff9967270"
    sha256 arm64_sonoma:  "3957858cee344323b79f139e3659f40112509a8a63305422c18a523f3a4ebd78"
    sha256 arm64_ventura: "fc6b29637b2e230ee3f969118df765352cc4c55c496ba0aa28b3ccd8db3fa762"
    sha256 sonoma:        "7bb2bc2ad093d1d9ab36698bb927dd6ace11ca733f300c18bf8f7299588cf1a4"
    sha256 ventura:       "905cc97f81a0215aa7b1c90b8679ed67e5446b1b533173f2a2d288b4db4fbc96"
    sha256 arm64_linux:   "74408397b4af6c258673102b7951aefbed87b8bf0522853139308b2e599d7e88"
    sha256 x86_64_linux:  "cff32d4cdcf1043c08056a4a3bcacb77de58c679c878bbe983f8de9fc75d438c"
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
