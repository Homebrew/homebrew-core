class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.14.tar.gz"
  sha256 "be120ba95d4490436f0da077ffa8f767bf727b82decf2bf499e39becc027809c"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gnutls"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("pkg-config --modversion nice")
    assert_match version.to_s, output
  end
end
