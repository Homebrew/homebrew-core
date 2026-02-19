class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/refs/tags/v1.9.23.tar.gz"
  sha256 "03cc7c0c2c825c3576350745a3c9a3644ca5a9282f5052602de2eceee0c4c347"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a65465e42cb84f558378c966a77ae8b7ca0409bc8686f89c62b4fc45d55bd18a"
    sha256 arm64_sequoia: "f1e6b353bd87fbe41d903d7580d4710d709597c2409b519ea0aaef820a369034"
    sha256 arm64_sonoma:  "738c308de152b3f2f9df6bbe41b8ba2b6e120759549f49281820693794384e11"
    sha256 sonoma:        "25ade32fb291157a367cb4900027b04baeb229a21aac12516ede7caa86b1a583"
    sha256 arm64_linux:   "85a884b0c94907488539fcd47a78530fe1102045e052dd14647bdcbcb4de4556"
    sha256 x86_64_linux:  "9bc6c13c652f278395d6a156d10b1f5cc9afccae9a123fb465b840d0eb9446be"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"

  on_linux do
    depends_on "gnutls"
    depends_on "zlib-ng-compat"
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
