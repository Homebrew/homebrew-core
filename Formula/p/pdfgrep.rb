class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.2.0.tar.gz"
  sha256 "0661e531e4c0ef097959aa1c9773796585db39c72c84a02ff87d2c3637c620cb"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fd50352b2273e2fe74cc1d743223ad274f9d5a8cc1f80a58995859c68a9f52e"
    sha256 cellar: :any,                 arm64_sonoma:  "5356bb2f208f6f5824dda4506b77d74629939da845eefde2865083efdfe9e986"
    sha256 cellar: :any,                 arm64_ventura: "8bb0312620765b07ff82bf65c78f3fb50d5a24a933c8fde3e227f614c37aecc3"
    sha256 cellar: :any,                 sonoma:        "d4996ec4f5eb3e90b4ba3c8ce8c442cbdbe00a8c7585e43ac766bf109b44f6d7"
    sha256 cellar: :any,                 ventura:       "e0033f368c2694317ecbcfe49eaf4efbf88f1e97e31f83252d3131132e84c659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7350f888b534ac62216fc4c50935be77b4a8e47620e8b188d4098c8b024b333a"
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libgcrypt"
  depends_on "pcre2"
  depends_on "poppler"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.cxx11
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
