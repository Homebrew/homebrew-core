class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.0/mdbtools-0.9.0.tar.gz"
  sha256 "8ce95f62c32f9c5c1c1dcb1c853a35b735e2158bf5ceb0c041e2e9557ff536af"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "0b35d9f656db9764cf1d52232e23e3f229e6884b657ae7f30ef4a16b6a6d4b27" => :big_sur
    sha256 "506fe9890406bbd6555de2899c70e00de6364f0e1d0835cc8915bb6fe21cce41" => :arm64_big_sur
    sha256 "3c14e11a6603273676d09141b8da9fed42bacd992dbb7d82979c1279ed488ba4" => :catalina
    sha256 "7ba58781f1d60f4b5ea1e9af6f75d52be36a7cfec10fef414e1e99d447ad10e5" => :mojave
    sha256 "57bc1d0d1df78a20881b0d0340a302ec3a7d359a80eaffe78d809bf4dc150521" => :high_sierra
    sha256 "1e1f75dc87ac2f423ecbf993a118220fe8d309ad179ec9986d099b98f959f216" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-sql",
                          "--enable-man"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
