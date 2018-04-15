class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.5.tar.gz"
  sha256 "3ee1415e7c48dc144fbdb99105a6ef8a818e67ed34e9d0f8e01224c3636cef0c"

  bottle do
    sha256 "1d0badeb96434bad76cba13bd4690e4ced3e2e30a0c96e1d0900d0937626b091" => :high_sierra
    sha256 "892f74789cc3126fe7cc9fd26cfa0bd07004e6ebd18baa5e814de804722cb376" => :sierra
    sha256 "eb4ab69456d6a37a9544a1b0c57ac2cae33029666899a3aae16bf9de60affcca" => :el_capitan
  end

  fails_with :clang do
    build 318
    cause "'#line directive requires a positive integer' argument in generated file"
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
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
