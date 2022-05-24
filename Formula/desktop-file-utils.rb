class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.26.tar.xz"
  sha256 "b26dbde79ea72c8c84fb7f9d870ffd857381d049a86d25e0038c4cef4c747309"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "39d2de6b778872be7de0e8f76d609eccc9c5f99546e48777ca0b24fe94bdf3cb"
    sha256 arm64_big_sur:  "c1bdcafb26625cd695365e41b4d3bb225d42c6075aa799c86b98e367a7d8ce9f"
    sha256 monterey:       "5fba0d6b08c4f7bb948be0d52b63095d9679962c8985f324682c27ca591cd29b"
    sha256 big_sur:        "de9ed12a55ebff6b2d321c91908219d3d0b7802080ad462774eb1179ec7435b1"
    sha256 catalina:       "fba87a1749b744c74510df1a49ed7627615ab10a2398922eac1389f4e35a5cb8"
    sha256 mojave:         "2e6548daf5b3fd3f038205986130d39390fd4b22955ed07ad06f6378d5e6e5f2"
    sha256 high_sierra:    "12e7bfe0f9a579f826f7c74f5a67d41ed4dee469f1cf0f3b4be89ef9e884996e"
    sha256 x86_64_linux:   "6431879e86450d555446ffbb3b1ffa1bc2cfee91c38a170dfcff7d09fb88253c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"

      # fix lisp file install location
      mkdir_p share/"emacs/site-lisp/desktop-file-utils"
      mv share/"emacs/site-lisp/desktop-entry-mode.el", share/"emacs/site-lisp/desktop-file-utils"
    end
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
