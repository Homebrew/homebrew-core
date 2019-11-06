class AutoconfAT213 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.13.tar.gz"
  sha256 "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d3b4d6e06ae6749fc60fa437f1f5c2ae85a91f6979ca897e08b854f920c222a0" => :catalina
    sha256 "5257ef101823cbf8d20693e27bf4505aec149c7d588459fedc2791a7906eb444" => :mojave
    sha256 "5257ef101823cbf8d20693e27bf4505aec149c7d588459fedc2791a7906eb444" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-suffix=213",
                          "--prefix=#{prefix}",
                          "--infodir=#{pkgshare}/info",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match "Usage: autoconf", shell_output("#{bin}/autoconf213 --help 2>&1")
  end
end
