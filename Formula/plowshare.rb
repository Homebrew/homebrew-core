class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.4.tar.gz"
  sha256 "d6bb484fe63a8e9219a3f284a9ad21e260e2fc21aa004eedfcac86fb65e8c13e"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf51f7730cba1c919599fd682cf39ef5ee3f4583da7b54c7e454681d48f686af" => :el_capitan
    sha256 "5fdbb23c6c90d72d9e362ab4a8ed3b65bf3b9c9a5a82e233d73f66863098e945" => :yosemite
    sha256 "fd04155ae4e86884f63731834f4a5b4b4746d534d376d091bc7df76065734646" => :mavericks
  end

  depends_on "aview"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "imagemagick" => "with-x11"
  depends_on "recode"
  depends_on "spidermonkey"

  def install
    system "make", "install", "patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed", "PREFIX=#{prefix}"
  end
end
