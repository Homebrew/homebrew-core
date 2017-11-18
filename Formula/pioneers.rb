class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.4.tar.gz"
  sha256 "9a0d3198dc0ddf131d9e6d6e9992347fe2a2d99f508f1be1b30c5797210a2ddc"

  bottle do
    sha256 "96e83542f86672e1b874b2dad3441333ad65d9b687262fc126da1a9b189dd52d" => :high_sierra
    sha256 "814dfc13c0cb4096ae6d84ab1b7210c1ef1c49e3f542bcb0adcac03e72e7384b" => :sierra
    sha256 "c6799c8d4de3d80c55a81b66b726dafdab710a16b40cf704cc6dadb5a96fba3f" => :el_capitan
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
