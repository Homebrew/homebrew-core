class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.2.0.tar.gz"
  sha256 "0661e531e4c0ef097959aa1c9773796585db39c72c84a02ff87d2c3637c620cb"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "3d659c7c01fe49631881b5b324c9951cd570ab8a1c57fd82515718245007bf33"
    sha256 cellar: :any,                 arm64_sonoma:   "633fdf9703a8e5bf2e912cc6005566ae42bf2b54658b611f911967afd7d1db14"
    sha256 cellar: :any,                 arm64_ventura:  "27acab326508534e95f2188d3c7bb6c4233fba992e1ff764099063498c4be597"
    sha256 cellar: :any,                 arm64_monterey: "881bdac5140488c24e2bbfd7943bb2c70438ab5eee974f702d62108c2dbd26cc"
    sha256 cellar: :any,                 sonoma:         "d9c657ebf312c7e65b013f4e3dd2d056ddff7d8a25ff6bd34fc8ad90fdc6c28e"
    sha256 cellar: :any,                 ventura:        "c3e85542c3a9556194e659652477bb90a04d487c68177849cbae3b71225576e2"
    sha256 cellar: :any,                 monterey:       "3f6beec10ef5fefe10b2edbd79e5a29c2e4bc1f22441bf2e39a190da83e3c692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d612d28c6b3c3b38ddb2501561ab464eab78afce88d1fb2537f3aa266ee6778"
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "pcre2"
  depends_on "poppler"

  on_macos do
    depends_on "libgpg-error"
  end

  fails_with gcc: "5"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.cxx11
    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
