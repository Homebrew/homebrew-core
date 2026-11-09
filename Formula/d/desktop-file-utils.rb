class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.29.tar.xz"
  sha256 "661f225be4c667abc4962f075717db4252b63c84480f6d37b26050d029da8fa0"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "13a8ed5b67571a08e0cc77c6c403eb94bb364cde3e1ecb47d250e9f04939422c"
    sha256 arm64_tahoe:       "672164493b9d75d0165c82965299a0a14fd13a5d37c7a9dbf9ec790aae184938"
    sha256 arm64_sequoia:     "affde13278895c14a46fc275448917d94f07acdcfadf7882808c5f238e98846e"
    sha256 arm64_linux:       "ead45e3d8224efa1d79fe4c080fa492878d56d525930a29d48c4f423f0d88348"
    sha256 x86_64_linux:      "f8af999b6bffa3fcf398297667a9441385c4a6fac26c2ac319e594021f8e0050"
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
