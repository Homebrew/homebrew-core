class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 4

  bottle do
    cellar :any
    sha256 "ca06202abe572f8741ef0a218c05d7d5e48b9d081457fe431d5a80e064ce8eb1" => :mojave
    sha256 "c72856d4fe5eb9d87927514950779c334f7e69ba407006b5a1d95855664b0b96" => :high_sierra
    sha256 "298de977286392989fece4a8ac93a9d2ffe3dfd5aeec3e899d46f9fe0f2652cb" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  # Fix "error: no template named 'auto_ptr' in namespace 'std'"
  # Upstream PR 20 Jun 2018 "C++14 (C++1y) should be the highest supported standard."
  # See https://github.com/hfst/hfst-ospell/pull/41
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/674a62d/hfstospell/no-cxx17.diff"
    sha256 "0a3146e871ac0e3c71248b8671d09f6d8a8a69713b6f4857eab7bdb684709083"
  end

  def install
    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
