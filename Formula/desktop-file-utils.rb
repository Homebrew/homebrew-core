class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz"
  sha256 "6c094031bdec46c9f621708f919084e1cb5294e2c5b1e4c883b3e70cb8903385"
  revision 1

  bottle do
    sha256 "c38944b2998cb74506a7cb10e621305db5b37d74d90aa7db51db146ccf378ca3" => :mojave
    sha256 "f3666dfcad0fda5049ef9b9a7ac85429b0fe5f4c81b12526694c18980b9a3708" => :high_sierra
    sha256 "67af40d090e09bfe3ce0f83d3f0cb910bd3762851131cc55ef9e434e85a11b11" => :sierra
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
