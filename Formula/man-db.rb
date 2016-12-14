class ManDb < Formula
  desc "Unix documentation system"
  homepage "http://man-db.nongnu.org/"
  url "https://download.savannah.gnu.org/releases/man-db/man-db-2.6.7.1.tar.xz"
  sha256 "8d65559838fccca774e3ef7c15c073180c786e728785c735e136297facca41fc"
  # tag "linuxbrew"

  head do
    url "git://git.sv.gnu.org/man-db.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    sha256 "3fa618e0db198499a32a305241e59dd31eb513ff5dedaf693fb674cb8b6612a4" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "groff" unless OS.mac?
  depends_on "libpipeline"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/man", "--version"
  end
end
