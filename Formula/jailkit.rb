class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.19.tar.bz2"
  sha256 "bebbf6317a5a15057194dd2cf6201821c48c022dbc64c12756eb13b61eff9bf9"

  bottle do
    sha256 "fb9867813bab48b93e031c4a3a3b8877647d1d2cd7caffb5bc0003b4f569d653" => :mojave
    sha256 "166941217a0df0400cd068f2b3d9859c8b1a30981488c28bc0d44b2a7d4eafb6" => :high_sierra
    sha256 "ac67228b1970793bc8f5e6b0f167bdda59890aa23717443baa58a5ee0e0efe98" => :sierra
    sha256 "9c46c69db017a018e9b4c92f613d99d22656d331962bef1da85c0ae782a172e1" => :el_capitan
    sha256 "b57b4205ede4e8dff0e09c386034e322f667ce4df739b02578579f844dfbe5e2" => :yosemite
    sha256 "dfd01ec63fdd8786b7bd224e3990ffb16f12f194c21bee144a2cd3b482d4d6b7" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
