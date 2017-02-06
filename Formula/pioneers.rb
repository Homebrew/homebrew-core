class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "http://pio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.3.tar.gz"
  sha256 "69afa51b71646565536b571b0f89786d3a7616965265f196fd51656b51381a89"

  bottle do
    revision 1
    sha256 "0d02dc33d3ad81b3a65a757b0c648aa6600de5916bd62b2c6c1cbdff45691724" => :el_capitan
    sha256 "536e2d8a7323e6a1107edc878505125b17677a8712e4d7a4dee12849fb51de18" => :yosemite
    sha256 "34b67317d7daa35ce99fcbeb24a30cde358554890d31837767cb67eba0989142" => :mavericks
  end

  fails_with :clang do
    build 318
    cause "'#line directive requires a positive integer' argument in generated file"
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
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
