class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.2.0/libqalculate-5.2.0.tar.gz"
  sha256 "20be13a39aea7f0371af789539cb285892f2e15d8240f29f9f380984e3446830"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "0e7317b6d133d2dd3a204f03718398d5cec0adac44aa0538d279e741b037000e"
    sha256                               arm64_ventura:  "9621677276bf9f71a7ba91d869f9a4d3dfe1c50b07799e2cf91b90f858154c73"
    sha256                               arm64_monterey: "a9ebaa4fd9ebf4bb7e128d5f24dc407e7e7d32251bcea773df355ed6f1bd709f"
    sha256                               sonoma:         "fb4e4cf7bc2e0310f0711bc0e54d77f479343ac1eaf04c02ef25e5798f53bceb"
    sha256                               ventura:        "a745a784d5d8c99b35db4cd80996b7daefca5b7f2ef3c136595b0cec4b1ce30d"
    sha256                               monterey:       "2a05cc3fcace8fc296f9cd6f8d12e39e1f0dc372cf291e131810d757e42930b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9330e38c81717eea6ab19772bad003f2ba681974ce80ca3c659c3149084f2b2c"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gmp"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "gmp"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
