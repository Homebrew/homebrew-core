class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.12.tar.gz"
  sha256 "820e4e4747a2a2ec7a2e9f06d2f5a353516362c22496a10a9834f871b877499a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5784189130cbced918c7792b3c70f0cc5c8796c0beb19dd5e9ae20b9a27f2201" => :sierra
    sha256 "b58d0b3a611a9e6538ef45f53220a29c0d6db0c3713982d7fdfdfdb9a11b3cc6" => :el_capitan
    sha256 "33b01aed14d4258567f14b68b7aa902827c9e8ef80255a740d77f2418935a220" => :yosemite
    sha256 "b4e39a75592588e134de07e8037bf01e0d6fc93dbe79af1f6f9e197ca8b288cb" => :mavericks
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
