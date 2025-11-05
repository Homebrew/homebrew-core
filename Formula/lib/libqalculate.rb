class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.8.1/libqalculate-5.8.1.tar.gz"
  sha256 "59588d69475cbb374b0b90ddef731802edd5b2da696ef706d0ca5fff4dbcfdfa"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "3b07faeec3822a3d1bb7bcf17a102d82306c3df17bbd0c6aae9b54f61bc7ee9c"
    sha256                               arm64_sequoia: "f37526ba62b73c9c13ed7ef9769a37c539c9c484e48783805cea50366d26b55c"
    sha256                               arm64_sonoma:  "fc12dfee241547f880da1b95bcef21b4687e33d93bae1253acf6aff0d0d3c268"
    sha256                               sonoma:        "a396ad117af60508bed43e707122c0163f1e76eb83d47358a61b87a9039222b8"
    sha256                               arm64_linux:   "726aa1c07ad7479f291b69f13b856e5e1b3e55c79c31c04d30e966352d1722c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd3fa1f5a42b79eaa89c53f099152f560287d35b07ac5664d4c48117a17425cc"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
