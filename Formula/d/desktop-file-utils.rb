class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.27.tar.xz"
  sha256 "a0817df39ce385b6621880407c56f1f298168c040c2032cedf88d5b76affe836"
  license "GPL-2.0"

  bottle do
    sha256 arm64_sonoma:   "a18a457a7c8955e7fc9750bc4e0d92d6d3f017d84872ff153cd5cc1922db20ec"
    sha256 arm64_ventura:  "3504ba209857ce3103f0302740b60adf51ec55860e189b93417548bbd7f30ddf"
    sha256 arm64_monterey: "1951c07197a6e243fac0f0be0465285d6222150173972f07f7b301c3198b380b"
    sha256 sonoma:         "be004fc74c4c29bee7e565a01c6ab5d4f8c25d0a74cbae6d8d797e6e2358e7d1"
    sha256 ventura:        "4586ef4910eb11eecc38ecbdba255d20714c033daf7d8a27685b583864830daf"
    sha256 monterey:       "dc488c68889342e10d870526bf8384e72d2a171d4149931f05eb3b49404c0489"
    sha256 x86_64_linux:   "78d6e240e8acf2052e585074d938cee18b729133737b165b60269f1a2e2d0305"
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
