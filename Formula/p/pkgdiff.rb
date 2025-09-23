class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/refs/tags/1.8.tar.gz"
  sha256 "4b44a933a776500937887134cf89b94a89199304c416ad05b2ac365cce1076d8"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d61bc9f1e348b223672343dccd6a023459f729576a4850d91406ef253ccaa8b0"
  end

  depends_on "binutils"
  depends_on "gawk"
  depends_on "wdiff"

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system bin/"pkgdiff"
  end
end
