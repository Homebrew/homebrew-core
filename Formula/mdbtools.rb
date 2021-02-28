class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.2/mdbtools-0.9.2.tar.gz"
  sha256 "d4ba2974f9d4f0198fa92c5df178af7f52cdc5e1b545b6d0c9d79cd782fca742"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "51482d465b9bf4315b80f9b4b31423dbf1349b24f29358fdf0e6ea9a87a12b0b"
    sha256 cellar: :any, big_sur:       "6a653b4fc6a4c990a1ea0f08085875010a1560fffcf100eafe0d81de52778464"
    sha256 cellar: :any, catalina:      "04bb52a1f30aed9209498ea4fdbdf1b575a290f931632a2b37d1e6433b43f7b7"
    sha256 cellar: :any, mojave:        "d2d9d42dee37437e5e9c6c701efd38b13456d59ebb1fb2fbebbcba8af7ff32c6"
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
