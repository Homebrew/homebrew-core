class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-2.2.0.tar.gz"
  sha256 "0661e531e4c0ef097959aa1c9773796585db39c72c84a02ff87d2c3637c620cb"
  license "GPL-2.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43c65c4fdb2f725fda1346cb7a8164d5877f570b8a91625b7dfd1ac09123f4e2"
    sha256 cellar: :any,                 arm64_sequoia: "e9abaaade9c08a64293b612c87e77ac66c7665e8ed7c60129f5253bb822be180"
    sha256 cellar: :any,                 arm64_sonoma:  "c19d0fd178078f5165bbc9cf90d558303da7e48fb0a7e58d66629e6024660445"
    sha256 cellar: :any,                 sonoma:        "30ee8819e93cff1c67e4f5ecbad366e00fa94cc834c3999e533967f9b649c29c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0238a85a206f54c6fe141721bcf345e02a6274dc95cafe2cc4690eac7b3a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b1777fcc905b1f41a679135059d92c0b5c1ef2ac560f409b5e69910014c99c"
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
