class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.5.tar.gz"
  sha256 "31a1d379b738b007ff000107b03562bf73ed5f05d7fa1ebef50082f0799a59ce"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "07e78e6164a68596314546a4a47251e378c1081cbdf12b9ea2756820ebdd317c" => :el_capitan
    sha256 "dd48bc1601b784affe7911585f1ff9ee02dc16c2202fd94c20d26e157beb4d98" => :yosemite
    sha256 "dd48bc1601b784affe7911585f1ff9ee02dc16c2202fd94c20d26e157beb4d98" => :mavericks
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
