class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.5.tar.gz"
  sha256 "31a1d379b738b007ff000107b03562bf73ed5f05d7fa1ebef50082f0799a59ce"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f39fc8027d33f36d51088e513195207d8a5a4d9f978342e1b2c2b2ea9e410b26" => :sierra
    sha256 "f39fc8027d33f36d51088e513195207d8a5a4d9f978342e1b2c2b2ea9e410b26" => :el_capitan
    sha256 "f39fc8027d33f36d51088e513195207d8a5a4d9f978342e1b2c2b2ea9e410b26" => :yosemite
  end

  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "imagemagick" => "with-x11"
  depends_on "libcaca"
  depends_on "recode"
  depends_on "spidermonkey"

  def install
    system "make", "install", "patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed", "PREFIX=#{prefix}"
  end
end
