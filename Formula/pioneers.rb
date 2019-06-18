class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.5.tar.gz"
  sha256 "3ee1415e7c48dc144fbdb99105a6ef8a818e67ed34e9d0f8e01224c3636cef0c"
  revision 1

  bottle do
    sha256 "6dc8e606ea4f6264f662d0516cb67bbf04f661adab74406f34d4b908faf1c91a" => :mojave
    sha256 "a7e66d500a9a0787038c1449da19471f451e350d35a1a4035e84144820c2c8df" => :high_sierra
    sha256 "b58b5deb27c32495b244527947330028e1d69b1000b6453727dab16ff7572b09" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "librsvg" # svg images for gdk-pixbuf

  def install
    # fix usage of echo options not supported by sh
    inreplace "Makefile.in", /\becho/, "/bin/echo"

    # GNU ld-only options
    inreplace Dir["configure{,.ac}"] do |s|
      s.gsub!(/ -Wl\,--as-needed/, "")
      s.gsub!(/ -Wl,-z,(relro|now)/, "")
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pioneers-editor", "--help"
    server = fork do
      system "#{bin}/pioneers-server-console"
    end
    sleep 5
    Process.kill("TERM", server)
  end
end
