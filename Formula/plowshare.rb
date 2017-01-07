class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.6.tar.gz"
  sha256 "2823f4bc82ad9b30c0c122a312125cb923acc55ce448c56a503e03fe0a4d97c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ede17ceb41fc2bcd01e99a234437f41ef3cedaa472961913d8af87152437f367" => :sierra
    sha256 "ede17ceb41fc2bcd01e99a234437f41ef3cedaa472961913d8af87152437f367" => :el_capitan
    sha256 "ede17ceb41fc2bcd01e99a234437f41ef3cedaa472961913d8af87152437f367" => :yosemite
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
