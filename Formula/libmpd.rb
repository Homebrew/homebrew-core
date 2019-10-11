class Libmpd < Formula
  desc "Higher level access to MPD functions"
  homepage "https://gmpc.wikia.com/wiki/Gnome_Music_Player_Client"
  url "https://www.musicpd.org/download/libmpd/11.8.17/libmpd-11.8.17.tar.gz"
  sha256 "fe20326b0d10641f71c4673fae637bf9222a96e1712f71f170fca2fc34bf7a83"
  revision 1

  bottle do
    cellar :any
    sha256 "a89b23f581da1a00a6c9cd077c854bb6b7f1c818664630cec1ed8f0b6f543a32" => :catalina
    sha256 "9a7f7829ec1d79442d3dade12c338b42a0f248b35aa25475b512f0b70171d8db" => :mojave
    sha256 "2d8f1fae6ecc3ab4b440531ae13a2db5bc82282a89f2670a986cc6136da16068" => :high_sierra
    sha256 "8518a3880db71a27a414e8e2ae020afec29afbb777694389cd57d983ec1904a5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
