class Esound < Formula
  desc "Enlightened sound daemon"
  homepage "http://www.tux.org/~ricdude/EsounD.html"
  url "https://download.gnome.org/sources/esound/0.2/esound-0.2.41.tar.bz2"
  sha256 "5eb5dd29a64b3462a29a5b20652aba7aa926742cef43577bf0796b787ca34911"

  bottle do
    sha256 "8debbe59ee5721a38c9e81e105942b61460f3eea25f2441bbf0a59cb764d154d" => :sierra
    sha256 "3716e941f802ccd1abf832350b7afbd39aea8d9c4e6d57712e20ecb894473f77" => :el_capitan
    sha256 "f280c15eb3bf09e99c99f450a778df21f993dc99a727eca1aeea0815aa065b72" => :yosemite
    sha256 "95ffbc82437fb77ef235de636c3b8ab8baebbecf3223e39ca084670095fcaee2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "audiofile"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end
end
