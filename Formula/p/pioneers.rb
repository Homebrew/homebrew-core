class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.6.tar.gz"
  sha256 "9a358d88548e3866e14c46c2707f66c98f8040a7857d47965e1ed9805aeb631d"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "adf66c9f80045db5ecfe7557d06d1e6aa95dc4a8e07c6d144106b350f5826c7c"
    sha256 arm64_sequoia:  "f8818813a32e582cfe48b07fea5acb1f9796fb529586e2b1d73eded630f64eb4"
    sha256 arm64_sonoma:   "322552b3012b80d29fbb86bd7986a9819857e34f37a4e25d5787ba891318f17f"
    sha256 arm64_ventura:  "e4593b8a69cf0aa9ce87ffe07240f877ec2462d6f2956d7757bc35656e7946d2"
    sha256 arm64_monterey: "9dc75e65f88e84ce1354958dab915fc80436b07ea720239479e1d82ead6fbd8c"
    sha256 sonoma:         "18c79c7b8137ddbb485fa0a501ab0b163dd08670370a25b8d1abbcac7032ccb7"
    sha256 ventura:        "120b652031fbd995e43ef02538d039e44c99f5b845901d329703fb5d027b6d27"
    sha256 monterey:       "b1f802ac210dbce9ce41084ea23c54af80519e44730546734b56dc2db6ae44f2"
    sha256 arm64_linux:    "dee6715b417bc783ebdce0da7c02b6bca21d1ffa02e6f84db1dad9d409abaee4"
    sha256 x86_64_linux:   "3efeb1b6c8a348562ebb969cbd877612cefe83e65b54bd52533f9bed290f8bc9"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "librsvg" # svg images for gdk-pixbuf
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    # fix usage of echo options not supported by sh
    inreplace "Makefile.in", /\becho/, "/bin/echo"

    # GNU ld-only options
    inreplace Dir["configure{,.ac}"] do |s|
      s.gsub!(" -Wl,--as-needed", "")
      s.gsub!(/ -Wl,-z,(relro|now)/, "")
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pioneers-editor", "--help"
    server = spawn bin/"pioneers-server-console"
    sleep 5
    Process.kill("TERM", server)
  end
end
