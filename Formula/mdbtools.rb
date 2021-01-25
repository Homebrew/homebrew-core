class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.1/mdbtools-0.9.1.tar.gz"
  sha256 "f62b4dcf06a43ad2b4342be670fc934d03886da9feb9f38434029facc0b98f3c"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "6a653b4fc6a4c990a1ea0f08085875010a1560fffcf100eafe0d81de52778464" => :big_sur
    sha256 "51482d465b9bf4315b80f9b4b31423dbf1349b24f29358fdf0e6ea9a87a12b0b" => :arm64_big_sur
    sha256 "04bb52a1f30aed9209498ea4fdbdf1b575a290f931632a2b37d1e6433b43f7b7" => :catalina
    sha256 "d2d9d42dee37437e5e9c6c701efd38b13456d59ebb1fb2fbebbcba8af7ff32c6" => :mojave
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
