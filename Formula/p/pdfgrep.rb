class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.2.0.tar.gz"
  sha256 "0661e531e4c0ef097959aa1c9773796585db39c72c84a02ff87d2c3637c620cb"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "502319a84275612510c2c810e08793ded8b119b837bd0794e89d98e03a287221"
    sha256 cellar: :any,                 arm64_sequoia: "9926375b2077d2480098e6d821880915a51f94a4c89284718d5b320609e00220"
    sha256 cellar: :any,                 arm64_sonoma:  "41dc9c7cfff5e4e580d773798cdf1bf190017ec15287aac86fbd44a7632f451a"
    sha256 cellar: :any,                 arm64_ventura: "7482070f52df00a9eb14f2728145b17828ab75d95083a6c4267ba899b0ffcf12"
    sha256 cellar: :any,                 sonoma:        "9dbe21ca4fa269567f10411c1d31eb3646151557b05905343782148f1c7b2e99"
    sha256 cellar: :any,                 ventura:       "1d6942180032f100bceabe2e78e4dd68556d60a4ee60b451c959ea5c552e56f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eabd87eaa34a322f3f330937baece415a67effbd2f5e6737c42f54581c96044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e547dc318109b9fb83fa11a59c5cf07608121c5be5173d34d7762dea0498b1"
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
