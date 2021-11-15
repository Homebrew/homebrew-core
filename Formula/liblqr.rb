class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  license "LGPL-3.0"
  revision 1
  head "https://github.com/carlobaldassi/liblqr.git"

  stable do
    url "https://github.com/carlobaldassi/liblqr/archive/v0.4.2.tar.gz"
    sha256 "1019a2d91f3935f1f817eb204a51ec977a060d39704c6dafa183b110fd6280b0"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "00c8af9f4f4818defb464b1543cdc820cf8c10c5b7ccf30a9b306ee96519ce66"
    sha256 cellar: :any,                 arm64_big_sur:  "5b55b5517f358ea17c882c7afcb02ef538fe032854a6a9e1f54785a35862adde"
    sha256 cellar: :any,                 monterey:       "491fd59fd84a8bc28963dc72b04c4f98de9d835379ae5712af83ff66a6331180"
    sha256 cellar: :any,                 big_sur:        "94977eaf2a6b9c9d52f178267ba034bb2515cb2ba0a643006c10f83ab6a532b9"
    sha256 cellar: :any,                 catalina:       "18803ed552ae07c1998c87ba6c4ebaee1ec5eaab843c2cfa2cc3775f0b55da23"
    sha256 cellar: :any,                 mojave:         "83054ddb4fffb94ea12f609a90082220a451bfdc793284d104f1fdeaf4aa8fd6"
    sha256 cellar: :any,                 high_sierra:    "43e9b4f518364d436b53c89b1ac42e2cfdcafc47fad1ba711bd6456122e47d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4d5b2822f5ceba9fff258d869110d23e2e6f2f06dd958a7a12d6333e8944c4"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
