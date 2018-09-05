class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 2

  bottle do
    cellar :any
    sha256 "3f05e2bbeee5f4efff3feb68ac32c1238e4cc4e6d2377f594a4fc1b46a46b0d7" => :mojave
    sha256 "276eda6c0865d79d468db9509daeaf537425597ffb88f983b1c0c97313b46b18" => :high_sierra
    sha256 "949b5bcc9566da8dc417cd5c1585790986d066d04fb926d7d38bd05dbed420d2" => :sierra
    sha256 "8db96d894473fa94b81ddcf40365cf4cd215d3aa8e9eab07210c0e4827a833cb" => :el_capitan
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

  needs :cxx11

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
