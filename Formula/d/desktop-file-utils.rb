class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.28.tar.xz"
  sha256 "4401d4e231d842c2de8242395a74a395ca468cd96f5f610d822df33594898a70"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "58ea38ae424ae85f68fef1140c866a220bee2ade0ec766bc833a23a4b66a554b"
    sha256 arm64_sequoia: "8bb73bc697264796509115e1b1e59f08624c671897793b6f2ca099441bb98c39"
    sha256 arm64_sonoma:  "3edd064195ecd88f224ddb354c5ddca08ccb5b3834ced11f6a32d70c684ee2f9"
    sha256 arm64_ventura: "742e551aae92506d4b627e8f34ef64ab38620c07fe776a8d8a9fe2a7fb564cbc"
    sha256 sonoma:        "0cc6bbad9d64a2b2edc4c55c06a5417e55c2566b15f3401828d1d64a7ad0953f"
    sha256 ventura:       "4d17379ae5028f3dfebc90aa1f4747edebb77f38ed58d53712e688bd05a0d864"
    sha256 arm64_linux:   "afe8ceef438b1ce5f1199ed7aab6c5ed1e0fe9478bba9b4c230246d11e21f2f7"
    sha256 x86_64_linux:  "ea37203ffdaf572e7da0e0991f31dad7effa361f41ed2eb9b549b1745996f308"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # fix lisp file install location
    mkdir_p share/"emacs/site-lisp/desktop-file-utils"
    mv share/"emacs/site-lisp/desktop-entry-mode.el", share/"emacs/site-lisp/desktop-file-utils"
  end

  test do
    (testpath/"test.desktop").write <<~DESKTOP
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
    DESKTOP

    system bin/"desktop-file-validate", "test.desktop"
  end
end
