class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.0.0/libqalculate-5.0.0.tar.gz"
  sha256 "591598dedbcbd80119de052559873530030b3510bca2b0758f088cfb7dafb2ee"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "0f99ad0f94ddebd4aaca03a496f4fb1e96ed057979a43fc342c4801ac47355d2"
    sha256                               arm64_ventura:  "f6cb74899726e0321342c15e7e8a715b4232e8857dd377cce92bc9588ee05efd"
    sha256                               arm64_monterey: "9c53c5155574c6de801f101666ab208b59771b5236583d47774eae05442d79f2"
    sha256                               sonoma:         "7a3e569a4090cdaf095422154b0c6145827db3ab6ab16c2145e68784383584df"
    sha256                               ventura:        "b92d0ba3aad9e324d4a8b0ca82f7c39fea1143b2feff34d4decf01a4288d4fc0"
    sha256                               monterey:       "8d465af76147e1dfb212d9d4904e3f7ecda9638e2f5e3f3353c82e228d5ac89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b56ded239d7cee990c892690b27efd0a89363fddd57a58dd260bca9662e9c7"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
