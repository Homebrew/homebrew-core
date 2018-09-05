class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz"
  sha256 "6c094031bdec46c9f621708f919084e1cb5294e2c5b1e4c883b3e70cb8903385"

  bottle do
    sha256 "c0538ee53f8e6f466cd601436f2a62209e871e41cbd2e2ef16ed38b2746b76ae" => :mojave
    sha256 "0a3b290ebd40ce3b911268125379b6a0cd839db7fdaf9d88751eb442e2b00e1f" => :high_sierra
    sha256 "a30b539cc22f037ccacfd1ff1993fbc6292e0fa399f2d796195a0870832bb12b" => :sierra
    sha256 "8c18c3fe21f8d2b1bdb4befdadd2b6dabbbe89dcb9ebb7fbaf4a8a3c7a2153a1" => :el_capitan
    sha256 "a6a09a60579ac8875cb92fbcf6177a860da6954c0aa61f323c66441211af0d1b" => :yosemite
    sha256 "ccca14604b32329e36acf15be710bdc1458410c4bd382b8708d4afba1b68177a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.desktop").write <<~EOS
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Foo Viewer
      Comment=The best viewer for Foo objects available!
      TryExec=fooview
      Exec=fooview %F
      Icon=fooview
      MimeType=image/x-foo;
      Actions=Gallery;Create;

      [Desktop Action Gallery]
      Exec=fooview --gallery
      Name=Browse Gallery

      [Desktop Action Create]
      Exec=fooview --create-new
      Name=Create a new Foo!
      Icon=fooview-new
    EOS
    system "#{bin}/desktop-file-validate", "test.desktop"
  end
end
