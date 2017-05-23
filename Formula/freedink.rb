class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine."
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftpmirror.gnu.org/freedink/freedink-108.4.tar.gz"
  sha256 "82cfb2e019e78b6849395dc4750662b67087d14f406d004f6d9e39e96a0c8521"

  depends_on "check"
  depends_on "sdl2_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "gettext"
  depends_on "libzip"
  depends_on "fontconfig"
  depends_on "pkg-config" => :build

  resource "freedink-data" do
    url "https://ftpmirror.gnu.org/freedink/freedink-data-1.08.20170401.tar.xz"
    sha256 "e8d3f3ff55b1a86661949d08d901740d65a6092027886fd791f6c315b9c7a7ff"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
    resource("freedink-data").stage do
      system "sed", "-i.bak", "-e", "s,^VERSION,#VERSION,", "-e", "s,^SOURCE_DATE_EPOCH,#SOURCE_DATE_EPOCH,", "-e", "s,xargs -0r,xargs -0,", "Makefile"
      version=Dir.pwd.split("/")[-1].split("-")[-1]
      source_date = Dir.pwd.split("/")[-1].split(".")[-1].match(/(\d{4})(\d{2})(\d{2})/).to_a[1..-1].join("-")
      source_date_epoch = Time.parse("#{source_date} 0:00 UTC").to_i
      system "make", "install", "VERSION=#{version}", "SOURCE_DATE_EPOCH=#{source_date_epoch}", "PREFIX=#{prefix}"
    end
  end

  test do
    FileTest.executable? "src/freedink" &&
    shell_output("#{bin}/freedink", "-vwis").split("\n").first == "GNU FreeDink 108.4"
  end
end
