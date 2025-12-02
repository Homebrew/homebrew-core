class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.3.1.tar.gz"
  sha256 "8fc4f0e0f274297063e5e7682089a32b65ac1b2d21cfa13c54b980520952def2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9a5ba88479f83d1f077cdb054acbaf51cc275172b3e0886bf8918a4d7cd73c88"
    sha256 arm64_sequoia: "f08e86cad864b6ab6f0693ce3cc7de801eabd3adff964961a06a3fab48a144ab"
    sha256 arm64_sonoma:  "d1de6f91523ebe6eaec2e2742aa8d0db011603e93b1e48a892a7e6c7f3e2d7a2"
    sha256 arm64_ventura: "bd11011eb704199e5d74c02ec1bc6ba4b33df94fe3d1998c121cd3e6b00b5ac2"
    sha256 sonoma:        "49dee2906de335de26346eed694ef5087d07bee8b4f143f0ceb9e5ba4c314a61"
    sha256 ventura:       "c1477bdb2ea050ab85f3b2dbf71eef8dcd75ce3b5a16856f94fb078e359608f2"
    sha256 arm64_linux:   "154f375276dabb568e96a0e9a1c83946a48b66908743375a7c1e2326b77f440b"
    sha256 x86_64_linux:  "d9eaeeda84f67ba660d9f70f6011a3e21883ee632b8918cc400f2e806afb28e2"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"
  depends_on "pango"

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
  end

  def install
    if OS.mac?
      ENV["LIBETPAN_CFLAGS"] = "-I#{Formula["libetpan"].opt_include}"
      ENV["LIBETPAN_LIBS"] = "-F#{Formula["libetpan"].opt_frameworks} -framework libetpan"
    end
    system "./configure", "--disable-silent-rules",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
