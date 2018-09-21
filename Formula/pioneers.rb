class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.5.tar.gz"
  sha256 "3ee1415e7c48dc144fbdb99105a6ef8a818e67ed34e9d0f8e01224c3636cef0c"

  bottle do
    sha256 "5fb252c345552e1d485f2dbc833cf47bf37037a0c71856c02fa05d2ec6a37f21" => :mojave
    sha256 "e65fd2300b96f0339eb72d955b7a44c3d941d1275828a9f9a2fcfb31fe5f5f3b" => :high_sierra
    sha256 "b93d58fda500c7774afe281663c69e09b846d59e5e8c44481195bbf715a39387" => :sierra
    sha256 "e366345048bf9d0ea67815050233846432d6bb8ef15bb5efd92e78e2a2384d1e" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "librsvg" # svg images for gdk-pixbuf

  fails_with :clang do
    build 318
    cause "'#line directive requires a positive integer' argument in generated file"
  end

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
